Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXIQSEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXIQSEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXIQSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:04:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbXIQSEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:04:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vMTmkeXqx3Ono5VnmP2LkI9rq2385JGhzDDgWg35W9pL81Xet4E6459do/4DW4ikn
	/rX3hQTGUinmbxKqjk6uw==
Message-ID: <6599ad830709171104s24ec2adbrea984a9a109f9d8e@mail.gmail.com>
Date: Mon, 17 Sep 2007 11:04:36 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: cpuset trouble after hibernate
Cc: "Simon Derr" <Simon.Derr@bull.net>,
       "Nicolas Capit" <nicolas.capit@imag.fr>, linux-kernel@vger.kernel.org,
       "Paul Jackson" <pj@sgi.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>
In-Reply-To: <20070915010807.b0055e7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070908204438.3bf03d85@localhost.localdomain>
	 <Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr>
	 <20070915010807.b0055e7e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Yeah.  Bug, surely.  But I guess it's always been there.
>
> What are the implications of this for cpusets-via-containers?
>

I don't think it should be any different from the previous version - I
tried to avoid touching those bits of cpusets where possible.

Paul
