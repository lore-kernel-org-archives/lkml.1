Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbXIBA5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbXIBA5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932885AbXIBA45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:56:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:58530 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbXIBA4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N7m/PAnaQvHbOo8ySGexuuLKOHnIstcKMaEhQzTqSWjWCRccO+2YyD+MSus14mkcoYvkd5u0CKJMRvCeIRQrzsVTuMrkbvHSeaTZ2wsmrZMJUJBDLMzlwUP4dIBG9wuWna39B7Zw7VHlvmjj8vl5HNsY5/SDoeYlCxSZSm6XTSA=
Message-ID: <91b13c310709011756n40ca15fao55d88d3754f0c292@mail.gmail.com>
Date: Sun, 2 Sep 2007 08:56:54 +0800
From: "rae l" <crquan@gmail.com>
To: "David Newall" <david@davidnewall.com>
Subject: Re: [PATCH 1/3] netlink: use the macro min(x,y) provided by <linux/kernel.h> instead
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, cr_quan@163.com
In-Reply-To: <46DA07B8.4050204@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188675959178-git-send-email-crquan@gmail.com>
	 <46DA07B8.4050204@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, David Newall <david@davidnewall.com> wrote:
> Denis Cheng wrote
> > +     order = get_bitmask_order(min(max, (unsigned long)UINT_MAX)) - 1;
> >
>
> Why doesn't this clash with the max define, also in linux/kernel.h?
They indeed don't clash,
the cpp included by gcc is intelligent enough, it know the
function-style definition of max in kernel.h, that's different from
the auto variable max here, so they don't clash with each other,

But I think the variable name "max" here is ambiguous, I changed it to
"limit", see my following patch [PATCH 2/3].

-- 
Denis Cheng
