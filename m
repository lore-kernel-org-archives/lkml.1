Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYFAVz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYFAVz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYFAVzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:55:50 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60676 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYFAVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:55:49 -0400
Message-ID: <48431BAA.4040902@keyaccess.nl>
Date: Sun, 01 Jun 2008 23:59:06 +0200
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
Subject: Re: [patch 09/15] PNP: make resource assignment functions return
 0 (success) or -EBUSY (failure)
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224933.163750253@ldl.fc.hp.com>
In-Reply-To: <20080530224933.163750253@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

> This patch doesn't change any behavior; it just makes the return
> values more conventional.
> 
> This changes pnp_assign_dma() from a void function to one that
> returns an int, just like the other assignment functions.  For
> now, at least, pnp_assign_dma() always returns 0 (success), so
> it appears to never fail, just like before.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

I believe it would a bit nicer to (as long as we're pretending it 
matters in the first place) pass the return value back up from 
pnp_check_foo() instead of returning -EBUSY always but <shrug>

Rene.
