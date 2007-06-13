Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbXFMJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbXFMJfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbXFMJe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:34:56 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:33585 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755082AbXFMJez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:34:55 -0400
Message-ID: <466FB758.1020104@aitel.hist.no>
Date: Wed, 13 Jun 2007 11:22:32 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: PC speaker
References: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com> <Pine.LNX.4.64.0706122223350.19578@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706122223350.19578@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Since you can set the x86's crystals frequency from 1193182 to 18 Hz
> (PIT_TICK_RATE / 1 to PIT_TICK_RATE / 65535) [*], you can never really
> bust it. But even then, what would a speaker do it was constanly given
> +5V? (I _suppose_ the other level is 0V, not -5V -- makes for easy 
> design.) That's IMO just like a sound file with volume(x) = 1, nothing 
> spectacular if you ask me.
>   

I guess a motherboard don't provide enough current to
burn out that speaker.

But generally, speakers that handle some maximum
alternating current *will* burn out if you give them
the same amount DC.  This becasue speakers
are designed to handle AC - some of the energy is dissipated
as sound waves, some as an alternating magnetic field,
some has heat. And the speaker moves, so moving
air helps cooling it.

A speaker getting DC converts all that current into heat only,
and it stands still so no extra cooling.  So it burns out.

Helge Hafting

