Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYFDUuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYFDUuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYFDUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:50:09 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:39557 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYFDUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:50:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked list
Date: Wed, 4 Jun 2008 14:50:09 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <4845D937.2000205@keyaccess.nl> <4846810B.2030301@keyaccess.nl>
In-Reply-To: <4846810B.2030301@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041450.10576.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 05:48:27 am Rene Herman wrote:
> On 04-06-08 01:52, Rene Herman wrote:

> ADS7181 in fact might as well delete the IRQ from the dependents and add
> "irq 2/9,10,11 High-Edge Optinal" in front as an independent same as 
> ADS7151. That way, all the cloning can go.

We currently clone for AZT0002 as well as ADS7181.  Can we do the
same for both?  It would be nice to get rid of the cloning code
if we can.

Bjorn


