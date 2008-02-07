Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbYBGV7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbYBGV7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760270AbYBGV7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:59:21 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:20932 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbYBGV7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ap7SUdcwTGpUT9WnYCmcp72Rkh7hIguHjx952K0tR9ir/pJoyt98OAPdDSEDUv/DBn+3Ugf2xfd2gaUrATCYTlddBzvQWjk2NrmhM3UIy5U6pm5inI/IX2b/43A/GvpvJetqR9y8cUf7JlogX3asMQ0MLM/EB86rNpa3MDjSy2c=
Date: Thu, 7 Feb 2008 16:59:07 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Alfred E. Heggestad" <aeh@db.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
Message-ID: <20080207165144.ZZRA012@mailhub.coreip.homeip.net>
References: <47AB5012.20509@db.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB5012.20509@db.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alfred,

On Thu, Feb 07, 2008 at 07:38:10PM +0100, Alfred E. Heggestad wrote:
> From: Alfred E. Heggestad <aeh@db.org>
>
> This driver adds support for USB VoIP phones using the CM109 chipset,
> such as Komunikate KIP-1000 and Genius G-talk. Keypad is scanned and
> events are reported to the input subsystem. The buzzer can be activated
> by sending SND_TONE or SND_BELL to the input device. The phone keymap
> can be selected in run-time by using the "phone" module parameter.
> The driver has been tested with linux 2.6.24 on i386, and also tested
> to build cleanly on AMD64.
> More testing and code review is welcome..
>

For a long time I was sitting on the patch not sure what to do about
the pound key, but I think we need to allocate separate keycodes for
remote controls and phones that work regardless of users keymap.

Another item is keymap for different devices - the best way to handle
it I think it to implement getkeycodes and setkeycodes methods for
the input device and have alternative keymaps loaded from userspace
instead of adding module parameters.

The rest of the driver looks great and I am sorry I was ignoring it
for so long.

-- 
Dmitry
