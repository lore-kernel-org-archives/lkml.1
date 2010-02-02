Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0BBJcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:32:21 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:37516 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0BBJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=CMkqUJMMGBXXYbzNG7b8DfRVYDOOT6dMYV+e9izHUt3YD9L/Yd/hrhUs1P/CP3NRAQ
         Ga0LzZinXFQwQd2xGyT4ApqoS+PJexqLPAtuBCqoLgl1xHk5CJeKhICejt9uHeuKYk+J
         K5bdro4uFba9PH7Xc9eOgiu6SdwbuA02lD33g=
From: Florian Fainelli <florian@openwrt.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 2 Feb 2010 10:31:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-server; KDE/4.3.2; x86_64; ; )
Cc: Andreas Mohr <andi@lisas.de>, Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       Takashi Iwai <tiwai@suse.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <20100201223001.GA17627@rhlx01.hs-esslingen.de> <201002020758.42141.oliver@neukum.org>
In-Reply-To: <201002020758.42141.oliver@neukum.org>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021031.49132.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 07:58:42 Oliver Neukum wrote:
> Am Montag, 1. Februar 2010 23:30:01 schrieb Andreas Mohr:
> > I took some time to add your patch to ehci-q.c / ohci-q.c
> > (for my *hci-ssb.c ASUS WL-500gP v2), on my now heavily patched-up
> > 2.6.31.9, but UNFORTUNATELY it kept locking up the same way as always
> > when stopping playback despite being damn sure this time that this patch
> > could have the potential to finally fix it ;)
> > (I had to replace memory.h with page.h on my arch though, to fix the
> > build)
> 
> A moment please. You are using ehci and ohci. Both are using dma.
> Why does this issue arise?

Because the BCM4710 CPU core is know to have cache problems and we have been 
trying to workaround this, your problem Andreas is imho a different one.
--
Regards, Florian
