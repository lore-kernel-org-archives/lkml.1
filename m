Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXBYP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXBYP7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 10:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXBYP7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 10:59:21 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1738 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974AbXBYP7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 10:59:20 -0500
Message-ID: <45E1B254.70801@xs4all.nl>
Date: Sun, 25 Feb 2007 16:59:16 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>	<20070221224027.GK22464@csclub.uwaterloo.ca>	<200702212355.25601.s0348365@sms.ed.ac.uk>	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl> <m3slcw68vr.fsf@maximus.localdomain>
In-Reply-To: <m3slcw68vr.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> I will try a different case with a different dual PCI riser card soon.
>> This Morex riser has DN20-31 or so, so more options.
> 
> OTOH I wonder how do they use DN 21-31? The board uses lines AD11 to AD31
> (21 lines) for selecting devices #0 - #20. 32-bit PCI bus has only 32
> address/data lines :-)
> 
> Perhaps they mean AD20-AD31 lines = device #9 - #0x14=20? If that is
> the case, you can try:
> - their "DN30" = device 0x13 = 19, which is apparently what the VIA riser
>   card does,

Got the Morex stuff here today.
Surprise: the (current) default jumper location is ID30.
