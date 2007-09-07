Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbXIGWBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbXIGWBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbXIGWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:01:42 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:15188 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXIGWBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YJrPdOh0lXMe0Y1t81XdH6hOPjCWc0FoVkrbnU0LVq9M5TkqYn4HzfxsyZofcZPM6uKEQEBk4PW8qNBh+QtmVa3xST/IvaSZtt2Lz4xmny1rkexBJoJpi3GXJMA8ae7JztZO/rxWwv4NTrmL5HjnXEp+r1YWvqq7vmn75889OYM=
Message-ID: <8b67d60709071501r61914b64tf8a179c192a9fa2e@mail.gmail.com>
Date: Fri, 7 Sep 2007 23:01:40 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH] Add support for keyboard on SEGA Dreamcast
Cc: "Paul Mundt" <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709042304.51510.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com>
	 <200709042304.51510.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/07, Dmitry Torokhov <dtor@insightbb.com> wrote:

>
> Are we guaranteed that the dc_kbd_callback is not running in a separate
> thread?
>
> Please also consider implementing support for changing keyma. Since
> the keymap is pretty full I think the best way is to copy the vanilla
> keymap into a per-device memory and set up keymap, keycodesize and
> keycodemax in input device structure.
>
> Thank you.
>
> --
> Dmitry
>

Dmitry - have now worked out at least one alternative keymap - for
European keyboards. But could you explain the above point? I have to
admit I am not too familiar with the input layer - having really taken
an old, and bit rot infested 2.4 driver and brought it up to standard
for 2.6 - and so I don't follow this point too well!

Can I treat keymaps as firmware and load from userspace? Or is there a
way of making this completely user configurable at runtime?

Any help from you, or any other reader, much appreciated.

Adrian
