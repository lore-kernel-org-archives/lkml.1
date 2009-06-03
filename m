Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZFCWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZFCWUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZFCWUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:20:08 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:54103 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZFCWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:20:07 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [regression, bisected] adb trackpad disappears after suspend to ram
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	<877hzty0hm.fsf@scholz.fias.uni-frankfurt.de>
	<200906032200.55563.rjw@sisk.pl> <200906032220.19915.rjw@sisk.pl>
Date: Thu, 04 Jun 2009 00:17:54 +0200
In-Reply-To: <200906032220.19915.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 3 Jun 2009 22:20:19 +0200")
Message-ID: <87tz2xynal.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday 03 June 2009, Rafael J. Wysocki wrote:                        
> [--snip--]                                                                 
>>                                                                          
>> In that case I have no idea why it breaks.                               
>
> Well, in fact I think there is an interrupt we shouldn't disable on        
> suspend,                                                                   
> but we need to figure out which one it is.                                 
>
> Can you please send me /proc/interrupts from your system?                  

Here you are:

           CPU0       
 21:         58   MPIC 1    Edge      PMac Output
 24:       3146   MPIC 1    Level     ide1
 25:     145796   MPIC 1    Level     VIA-PMU
 26:         79   MPIC 1    Level     keywest i2c
 29:        196   MPIC 1    Level     ohci_hcd:usb2
 30:          0   MPIC 1    Edge      PMac Input
 39:      22058   MPIC 1    Level     ide0
 40:          2   MPIC 1    Level     ohci1394
 41:          0   MPIC 1    Level     eth0
 42:       3612   MPIC 1    Level     keywest i2c
 47:       5551   MPIC 1    Level     GPIO1 ADB
 48:      18938   MPIC 1    Level     radeon@pci:0000:00:10.0
 52:       5310   MPIC 1    Level     b43
 61:          0   MPIC 1    Edge      Sound Headphone Detection
 63:          0   MPIC 1    Level     ehci_hcd:usb1, ohci_hcd:usb3, ohci_hcd:usb4
BAD:          0

