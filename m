Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYHUIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYHUIa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYHUIaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:30:09 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36324 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYHUIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:30:07 -0400
Message-ID: <48AD273C.5090108@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 10:28:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ALSA pisses me off
References: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
In-Reply-To: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> # cat /proc/asound/cards
>  0 [VirMIDI        ]: VirMIDI - VirMIDI
>                       Virtual MIDI Card 1
>  1 [Speakers       ]: USB-Audio - Speakers
>                       Apple Computer, Inc. Speakers at
> usb-0001:10:18.0-2.2, full speed

I don't actually know audio, but this is what I think would solve it:

You probably don't need virmidi.  Try not to load it.  Or configure it
via modprobe to be the last enumerated card.
http://www.tldp.org/HOWTO/MIDI-HOWTO-10.html section 10.2.

Better would of course be if the combination of one or more audio device
drivers with virmidi required no configuration for basic functionality.
-- 
Stefan Richter
-=====-==--- =--- =-=-=
http://arcgraph.de/sr/
