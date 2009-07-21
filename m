Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZGUM4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZGUM4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZGUM4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:56:11 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:24031
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753068AbZGUM4K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:56:10 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R98dNzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN4ULE-03-MPP-01
Date: Tue, 21 Jul 2009 14:56:00 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com,
       aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090721125600.GG32338@aftab>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
 <1248106385-27514-8-git-send-email-borislav.petkov@amd.com>
 <20090720180446.GB16072@basil.fritz.box>
 <20090721104443.GC32338@aftab>
 <20090721110458.GB29028@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090721110458.GB29028@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 12:56:00.0178 (UTC) FILETIME=[98B65920:01CA0A02]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 01:04:58PM +0200, Andi Kleen wrote:
> > > It would be probably cleaner if you defined a standard
> > > notifier chain interface.
> > 
> > Sounds like a cleaner solution, at a first glance. Will look into it.
> 
> Actually on second though a notifier chain is a bad idea
> because there is too much risk having bad modules mess
> up machine check handling. It's a critical path like
> oops handling.

Which even stronger advocates placing MCE decoding into the EDAC core,
as Doug suggested. The DRAM address to DIMM mapping could still stay in
the module, being not critical path and all.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

