Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYAYOj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYAYOj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYAYOjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:39:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:5759 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYAYOjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tsgHZLad+CaWoTPnZgvApvPeGglChtmt9smnNYWx8l0r0aoyCv5C9NIpI2Ysvz6vs4qxBvHNdFvMJB8PS4fuACzpmWQDNW4H80ZNrofXCvQsqhnZAnro+W1/3LNV1thLusEjF4GIFmJ+mRDIiRG2PHipFpI5W92QAA0MzlzdP0k=
Message-ID: <a72f6a3c0801250639i4a7858eem415594f5663a9c7e@mail.gmail.com>
Date: Fri, 25 Jan 2008 14:39:17 +0000
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Q: linux failed to execute /init?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801251524510.15243@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com>
	 <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
	 <Pine.LNX.4.64.0801251524510.15243@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 2:27 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>
> On Jan 25 2008 13:40, Jack Harvard wrote:
> >Hi,
> >
> >I'm trying to boot Linux, but the /init process failed. Here is the
> >info:
> >
> >=FF<6>/init exit code: -14
> >/init exit code: -14
> ><4>Failed to execute /init
> >Failed to execute /init
> > <6>/sbin/init exit code: -14
> >
> >Just wondering what do those different exit codes mean?
>
> asm-generic/errno-base.h:#define EFAULT 14 /* Bad address */
>

Also, before the init process hung up and printed out /init exit code:
-14, it printed out the following symbol
ÿ
Which doesn't make any sense to me, just wondering what could have
caused this? it's unlikely due to baud rate and printed out something
unreadable.
