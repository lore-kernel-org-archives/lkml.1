Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbYFNKke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbYFNKke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYFNKkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:40:16 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:55071 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYFNKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:40:14 -0400
Message-ID: <485382EA.9080809@keyaccess.nl>
Date: Sat, 14 Jun 2008 10:35:54 +0200
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
Subject: Re: [patch 16/18] PNP: remove extra 0x100 bit from option priority
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221129.955112741@ldl.fc.hp.com>
In-Reply-To: <20080604221129.955112741@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-06-08 00:09, Bjorn Helgaas wrote:

> When building resource options, ISAPNP and PNPBIOS set the priority
> to something like "0x100 | PNP_RES_PRIORITY_ACCEPTABLE", but we 
> immediately mask off the 0x100 again in pnp_build_option(), so that
> bit looks superfluous.
> 
> Thanks to Rene Herman <rene.herman@gmail.com> for pointing this out.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene

