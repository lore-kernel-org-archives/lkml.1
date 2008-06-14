Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYFNKks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYFNKks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYFNKkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:40:17 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49987 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYFNKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:40:14 -0400
Message-ID: <48537BAE.2060400@keyaccess.nl>
Date: Sat, 14 Jun 2008 10:05:02 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 01/18] PNP: add pnp_possible_config() -- can a device
 could be configured this way?
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221126.945714835@ldl.fc.hp.com>
In-Reply-To: <20080604221126.945714835@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-06-08 00:09, Bjorn Helgaas wrote:

> As part of a heuristic to identify modem devices, 8250_pnp.c
> checks to see whether a device can be configured at any of the
> legacy COM port addresses.
> 
> This patch moves the code that traverses the PNP "possible resource
> options" from 8250_pnp.c to the PNP subsystem.  This encapsulation
> is important because a future patch will change the implementation
> of those resource options.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

