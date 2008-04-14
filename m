Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYDNBfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYDNBfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYDNBfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:35:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:3089 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYDNBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T0rgfUcHfo4Gi/l4m6+jer3JTltJbNhqQacj37UHn7mnsTxWrAzwrb7XBvfEcKbLMRMpOmbKUZ2LsZ+yhH4V3aYciaVfsyAVhJ91z5MJ/ImgrL1nqK3r2LSWnAJTiT7oseA22SYO4u51jLpGSj87oBuYLZ8c2eU17audK3pklLY=
Message-ID: <a8e1da0804131835t76a9ed61qbcd507ecd65a894a@mail.gmail.com>
Date: Mon, 14 Apr 2008 09:35:05 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: devzero@web.de
Subject: Re: netsc520 - skeleton in the closet ?
Cc: linux-kernel@vger.kernel.org, cebbert@redhat.com, jeremy@goop.org
In-Reply-To: <237143435@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <237143435@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 8:45 PM,  <devzero@web.de> wrote:
> i'm doing some module testing from time to time and i'm somewhat sure, that there is an issue with netsc520 module, as i have seen more than one occasion that after load/unloading of that module (w/o presence of the appropriate hw), other modules had issues.
>
>  see http://marc.info/?l=linux-kernel&m=120664963508105&w=2 for example.
>
>  now,by chance i came across this one: http://marc.info/?l=linux-kernel&m=118274309325836&w=2
>
>  >> > >> netsc520 is doing iounmap() of an area it did
>  >> > >> ioremap_nocache() on earlier, because it has now failed to
>  >> > >> find a device. Why it went BUG() I have no idea.
>  >> > >>
>  >> > >
>  >> > > Hi, maybe some config option cause this issue, here is my current
>  >> > > working-ok config file:
>  >> >
>  >> > What are the differences from the non-working config?
>  >> >
>  >> >     J
>  >> >
>  >> The diffrences is net520c item.
>  >>
>  >sorry it is netsc520, I will post the patch after a while.
>
>  so, it sounds there is a known issue with netsc520, but i'm not sure if it's the related and if that mentioned patch has been posted, at least i don't find it in git due to x86/64 unification.

Please see:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9585116ba09f1d8c52d0a1346e20bb9d443e9c02

>
>  maybe someone has a clue.... ?
>
>  _____________________________________________________________________
>  Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
>  http://smartsurfer.web.de/?mc=100071&distributionid=000000000066
>
>
