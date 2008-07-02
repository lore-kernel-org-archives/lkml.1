Return-Path: <linux-kernel-owner+w=401wt.eu-S1763209AbYGBJRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763209AbYGBJRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYGBJRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:17:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:55890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYGBJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:17:30 -0400
Message-ID: <486B47A8.3090809@suse.de>
Date: Wed, 02 Jul 2008 11:17:28 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] aic7xxx: debloat
References: <200807011848.22599.vda.linux@googlemail.com>
In-Reply-To: <200807011848.22599.vda.linux@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

Denys Vlasenko wrote:
> Hi Hannes,
> 
> aic7xxx still contains ~30kb of dead code if pretty printing of registers
> is requested. These patches deal with it.
> 
> I did not get any feedback from you whether the approach of adding
> "dont_generate_debug_code" marker would be acceptable despite
> asking twice. I decided that it's a "Yes".
> 
Well, yes. Sort of.

Patches are okay in principle, only it would be best if you could hook
the dont_generate_debug_code marker to the AIC79XX_DEBUG_ENABLE config option.
This way anyone interested in doing sequencer debugging would still get
the full sequencer code (which can be quite helpful at times).
And it would be disabled for the unsuspecting user.

Apart from this: well done.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
