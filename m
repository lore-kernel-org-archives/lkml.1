Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZIYTuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZIYTuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZIYTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:50:17 -0400
Received: from relais.videotron.ca ([24.201.245.36]:53649 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZIYTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:50:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 25 Sep 2009 15:50:19 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Frans Pop <elendil@planet.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Lennert Buytenhek <buytenh@marvell.com>
Subject: Re: arm: current mainline fails to boot on QNAP TS-109
In-reply-to: <200909252039.19789.elendil@planet.nl>
Message-id: <alpine.LFD.2.00.0909251547450.4997@xanadu.home>
References: <200909252039.19789.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009, Frans Pop wrote:

> Current mainline kernel fails to boot on my QNAP TS-109 (orion5x).
> 
> It fails immediately after uncompressing the kernel, there are no other 
> messages on the serial console. The problem was probably introduced in the 
> last ARM merge:
> 
> v2.6.31-8766-gf25f60b is OK
> v2.6.31-8936-g851b147 fails
> 
> If needed I can run a bisect between those commits.

No need -- I found the screw-up.  Will submit a patch right away.

In the mean time just revert commit 200b812d00.


Nicolas
