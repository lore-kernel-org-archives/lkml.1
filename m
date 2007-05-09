Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbXEIWj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbXEIWj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXEIWjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:39:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54835 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXEIWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:39:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46424D44.2040003@s5r6.in-berlin.de>
Date: Thu, 10 May 2007 00:37:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <alpine.LFD.0.98.0705081123080.3974@woody. <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm> <46424963.7070209@cfl.rr.com>
In-Reply-To: <46424963.7070209@cfl.rr.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Considering the particular case of scsi disks, you want to do
> the long INQUIRY command to probe each target in phase 2, so that this
> time consuming step can be done in parallel between multiple scsi
> busses.

The SCSI stack already has infrastructure for multi-threaded discovery
and probing.
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/
