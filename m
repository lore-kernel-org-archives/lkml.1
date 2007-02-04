Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXBDT3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXBDT3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXBDT3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:29:37 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:52259 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbXBDT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sdi2/91YBTTWW3RQIzfHN64/VzFTvqTwhZ6EIVgH1onjTzUCAOCiaGsLEMWGgNObVhFuxsuo1rKGmxd80MwHcTiLRvfT1KiE5PQv67VYHXt/dVsVVoQEG+DlyZqJOd6Nd1B/aeNYMIvtaEr7DLv4pT6K8XX1e37k3e5/2IbzuqM=
Message-ID: <8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
Date: Sun, 4 Feb 2007 20:29:36 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: More pata_ stuff
Cc: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20070204193441.6746bbca@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	 <45C619FC.3040804@shaw.ca>
	 <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	 <200702041910.46421.s0348365@sms.ed.ac.uk>
	 <20070204193441.6746bbca@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:

> PATA_OLDPIIX drives the PIIX (the original not PIIX3,4, etc)
>
> People do find that confusing so if there is any rewording for
> Configure.help that would have made it easier and more obvious let me know
>

Okay so.. what do I define now to use libsata with this controller?

I thought PATA_OLDPIIX would be it, like it is just that for VIA,SIL
and Promise.

And, maybe its a good idea to make it so that if you select
PATA_OLDPIIX it automaticly selects the dependencies aswell? I see
this happen a lot with other kernel things, like V4L2 and so.
Obviously just selecting PATA_OLDPIIX makes you have a half-configured
kernel config for this controller, and i used "make menuconfig", I
didnt manually edit the .config file.
