Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbZHURZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbZHURZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbZHURZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:25:52 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:44920 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbZHURZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t/9t6wV8WHjB6yQmw817N9T0rGbu7NjxyexOCcyLgGJ6ahq4L89kSX00j2KD6iVCvh
         VTs5xw6FlIbx/p2+Pc8/S63dQ1D1qE4BvwVxDR7YygMrrxlHEu7H6PZ7pzqDQ8tywzHz
         4Q9l6wP3FDIHoY264lU9WSOmb+O6ZDYMJeZ9Y=
Message-ID: <4A8ED89A.7090609@lwfinger.net>
Date: Fri, 21 Aug 2009 12:25:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-21
References: <20090821170324.GC8532@tuxdriver.com>
In-Reply-To: <20090821170324.GC8532@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> Dave,
> 
> One more straggler for 2.6.31...without this rtl8187b devices simply
> don't work. :-(
> 
> The patch is small and isolated to rtl8187.  I think we should take
> it for 2.6.31.

Note: This patch should fix Bugzilla #13960, which is a regression
since 2.6.30. The OP has not yet reported back, but it fixed the same
condition on my computer.

