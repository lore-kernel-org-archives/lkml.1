Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYCaIsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYCaIsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCaIs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:48:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44367 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYCaIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:48:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47F0A4FD.7040502@s5r6.in-berlin.de>
Date: Mon, 31 Mar 2008 10:46:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] FireWire update
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de> <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de> <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de> <tkrat.948f418ebe464164@s5r6.in-berlin.de> <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de> <tkrat.2374baeb26921d92@s5r6.in-berlin.de> <tkrat.85f36e56e03746e3@s5r6.in-berlin.de>
In-Reply-To: <tkrat.85f36e56e03746e3@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following update for the firewire subsystem.
> 
>  drivers/firewire/fw-ohci.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> Jarod Wilson (1):
>       firewire: fw-ohci: plug dma memory leak in AR handler

Ping.

This stops firewire-ohci from feeding random arguments to 
dma_free_coherent().
-- 
Stefan Richter
-=====-==--- --== =====
http://arcgraph.de/sr/
