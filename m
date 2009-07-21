Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZGUMxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZGUMxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZGUMxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:53:07 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:11642
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755226AbZGUMxD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:53:03 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R98dNzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN4UG0-04-QRV-01
Date: Tue, 21 Jul 2009 14:52:47 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Doug Thompson <norsk5@yahoo.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding II
Message-ID: <20090721125247.GF32338@aftab>
References: <20090720180446.GB16072@basil.fritz.box>
 <935428.51568.qm@web50110.mail.re2.yahoo.com>
 <20090720194419.GD16072@basil.fritz.box>
 <20090721105105.GE32338@aftab>
 <20090721110705.GC29028@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090721110705.GC29028@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 12:52:46.0843 (UTC) FILETIME=[2579C4B0:01CA0A02]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 01:07:05PM +0200, Andi Kleen wrote:
> On Tue, Jul 21, 2009 at 12:51:05PM +0200, Borislav Petkov wrote:
> > On Mon, Jul 20, 2009 at 09:44:19PM +0200, Andi Kleen wrote:
> > 
> > > As far as I can see this whole thing barely works even on AMD
> > > due to the other problems.
> > 
> > Care to let us in on those so that we get a chance to fix them?
> 
> Like I described in my earlier emails. You don't even catch CE errors
> which are the 90%+ case.

Yep, I want to tackle one problem at a time. Right now I'd like
to concentrate on decoding MCEs reliably and then we'll sort out
who/where/how decodes which types or errors.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

