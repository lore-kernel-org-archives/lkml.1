Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbXFMKlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbXFMKlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXFMKlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:41:42 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:37475 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757004AbXFMKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:41:41 -0400
Message-ID: <466FC9E2.9060306@grupopie.com>
Date: Wed, 13 Jun 2007 11:41:38 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: PC speaker
References: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com> <Pine.LNX.4.64.0706122223350.19578@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64N.0706131119010.7198@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0706131119010.7198@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Tue, 12 Jun 2007, Jan Engelhardt wrote:
> 
>>> 4) It assumes the current will be sufficient to burn out the speaker. (I
>>> know it will get very hot on older machines, whether it will burn out --
>>> might even depend on the exact speaker model.)
>> Since you can set the x86's crystals frequency from 1193182 to 18 Hz
>> (PIT_TICK_RATE / 1 to PIT_TICK_RATE / 65535) [*], you can never really
>> bust it. But even then, what would a speaker do it was constanly given
> 
>  I am fairly sure you have a choice between a steady low and a steady high 
> level on the speaker output available if you switch the 8254 to the right 
> single-shot mode.  In case you have not been into such details -- the 8254 
> offers six modes of operation, selected for each channel separately, of 
> which only two are periodic.

Can we please stop this non-sense thread? Anyone designing the speaker 
circuit would certainly place a small capacitor in series with the 
speaker to kill the DC component of the signal.

Since the speaker itself wouldn't be able to play very low frequencies 
anyway, the capacitor wouldn't have to be that big.

So I'm pretty sure that on any half-way decent piece of hardware, you 
won't be able to kill the speaker with software...

-- 
Paulo Marques - www.grupopie.com

"Don't hit a man when he's down -- kick him; it's easier."
