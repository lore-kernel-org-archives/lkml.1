Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZG3LK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZG3LK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZG3LK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:10:26 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:5236 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZG3LKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:10:22 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1431J1432R98dN148cMzz1202hzzz32i6bh203h6di43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNLDP0-03-R8B-01
Date: Thu, 30 Jul 2009 13:09:39 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Message-ID: <20090730110938.GA16659@aftab>
References: <20090730154150.d4c326b5.sfr@canb.auug.org.au>
 <20090730062309.GA15057@liondog.tnic>
 <20090730170850.6d777e96.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090730170850.6d777e96.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Jul 2009 11:09:39.0463 (UTC) FILETIME=[3B3A4170:01CA1106]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jul 30, 2009 at 05:08:50PM +1000, Stephen Rothwell wrote:
> > thanks for fixing that. Yep, the topology patches in the edac tree are
> > not final yet, I've added them to the mix only because edac depends on
> > the node_id functionality. I'll fix them up later against the rr stuff.

I rediffed the topology bits against
cpumask:remove-topology_core_siblings-and-topology_thread_siblings-core.
patch from Rusty's tree so we should be good to go.

Also, I'm carrying couple of patches that should go through the x86 tree
and depending on when they go in, I'll drop them from mine. Just wanted
to give you heads up here in case you start getting merge conflicts :).

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

