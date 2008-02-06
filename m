Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYBFPVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYBFPVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYBFPU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:20:59 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:57347 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYBFPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:20:58 -0500
Message-ID: <47A9D09A.4080809@keyaccess.nl>
Date: Wed, 06 Feb 2008 16:22:02 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc - Yet
 another Version
References: <1200772810.3708.42.camel@queen>	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>	 <1201536284.20940.424.camel@queen.suse.de> <479E19C9.7020201@keyaccess.nl>	 <1201547548.20940.435.camel@queen.suse.de> <479E4531.9050600@keyaccess.nl>	 <1202235600.14573.283.camel@queen.suse.de> <1202308725.7977.92.camel@queen.suse.de>
In-Reply-To: <1202308725.7977.92.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-02-08 15:38, Thomas Renninger wrote:

> I expect on Rene's machine (might be something else, but this probably
> often happens), BIOS exports dma and IO ports. The irq seem to be
> missing and the driver does not use pnp_irq_valid, but pnp_irq. It

No. Please note we're talking about ISAPnP, not PnPBIOS. No BIOS involved at 
all.

Driver (sound/isa/cs423x/cs4236.c) furthermore does not use anything but the 
PnP layer itself. Start at snd_cs423x_pnpc_detect, which is the pnp .probe() 
method.

I'll look into providing a more extensive answer and/or test whatever comes 
in later.

Rene.
