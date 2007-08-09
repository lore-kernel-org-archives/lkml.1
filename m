Return-Path: <linux-kernel-owner+w=401wt.eu-S939322AbXHIMbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939322AbXHIMbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765504AbXHIMbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:31:44 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:36155 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763610AbXHIMbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ONwhBPyyIcVxs+VQhXZUH/RG9kAJaX017AVtpiizwrALkGyl09HfavTY22ZdHrFDNpluoEVzAH9fo29nitYmqkgFhuGj54mlJhVD2PD1yAS8ypO/RsXciM2BofjSDh5No2sTphgW9GXTMcfDkEWPQbkClKFX6amI/OSCCi4KEhA=
Message-ID: <40f323d00708090531p34f1fffcub5186d358f9beafb@mail.gmail.com>
Date: Thu, 9 Aug 2007 14:31:41 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Chris Holvenstot" <cholvenstot@comcast.net>
Subject: Re: Kernel / Fliesystem Error
Cc: "Chris Holvenstot" <saltydog@houston.rr.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1186658730.7018.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186623555.6613.17.camel@localhost>
	 <1186658730.7018.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Chris Holvenstot <cholvenstot@comcast.net> wrote:
> > Chris Snook wrote:
> >
> >The problem here is that your clock is wrong either at mount (boot)
> >time or unmount (shutdown) time. There's nothing wrong with ext3,
> >except that it happens to be noticing this condition.
>
> 1.  This happens even when the system is rebooted via the shutdown -r
> command - not much time for my fat fingers to get in there and dork up
> the system clock.
>
> 2.  As I stated in the original note, this does NOT happen with kernel
> 2.6.22.1 - so far I have only seen it with the 2.6.23-rc1, rc2, and
> rc2-git1 kernels.
>

But very likely time keeping was broken between .22 and .23-rc.
Probably not ext3.

regards,

Benoit
