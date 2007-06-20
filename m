Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXFTJ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXFTJ6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXFTJ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:57:57 -0400
Received: from styx.suse.cz ([82.119.242.94]:51886 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755558AbXFTJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:57:56 -0400
Date: Wed, 20 Jun 2007 12:00:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz> 
 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com> 
 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz> 
 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com> 
 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz> 
 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com> 
 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com> 
 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Renato Golin wrote:

> Applied your patch and the log is below,
[...]
> [ 6973.596722] calling input_set_abs_params, code: 0, min: ffffff81,
> max: 7f, fuzz: 0, flat: f
> [ 6973.596724] Absolute.X
> [ 6973.596732] calling input_set_abs_params, code: 1, min: ffffff81,
> max: 7f, fuzz: 0, flat: f
> [ 6973.596735] Absolute.Y

Hi Renato,

this signalizes something is wrong between the device and HID layer - it 
could be both the report descriptor of the device being wrong, or some bug 
in hid-input that is not triggered by any other device.

Could you please send me the report descriptor of the device, so that I 
could debug it locally here?

The report descriptor should be present in your HID_DEBUG dump, but you 
don't seem to have provided in any of the previous mails. The relevant 
line in dmesg should look similar to:

report descriptor (size 61, read 54) = 05 0b 09 05 a1 01 05 09 19 11 29 18 
15 00 25 01 75 01 95 08 81 22 05 08 09 3a a1 02 05 09 19 11 29 17 15 00 25 
01 75 01 95 07 b1 a2 c0 06 ff ff 09 01 15 00 25 01 75 01 95 01 b1 22 c0

Thanks,

-- 
Jiri Kosina
SUSE Labs
