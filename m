Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbYESXYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbYESXYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761103AbYESXVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:41 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49389 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761119AbYESXVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:24 -0400
Message-ID: <48320A0B.7040008@keyaccess.nl>
Date: Tue, 20 May 2008 01:15:23 +0200
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
Subject: Re: [patch 3/4] PNP: remove ratelimit on add resource failures
References: <20080515220726.029505668@ldl.fc.hp.com> <20080515220754.916930897@ldl.fc.hp.com>
In-Reply-To: <20080515220754.916930897@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-05-08 00:07, Bjorn Helgaas wrote:

> We used to have a fixed-size resource table.  If a device had
> twenty resources when the table only had space for ten, we didn't
> need ten warnings, so we added the ratelimit.
> 
> Now that we can dynamically allocate new resources, we should
> only get failures if the allocation fails.  That should be
> rare enough that we don't need to ratelimit the messages.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene

