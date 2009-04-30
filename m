Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbZD3KBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbZD3KBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZD3KBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:01:16 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36575 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZD3KBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:01:15 -0400
X-BigFish: VPS-21(zz1432R98dR1805M1442J936fJzz1202hzzz32i6bh6di15fn61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KIWRTN-02-P75-01
Date: Thu, 30 Apr 2009 12:01:00 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-ID: <20090430100100.GB20167@aftab>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-14-git-send-email-borislav.petkov@amd.com> <20090429182255.GD8321@elte.hu> <20090429120501.ae005dc4.akpm@linux-foundation.org> <20090429192326.GA14652@elte.hu> <20090429124228.8677d4eb.akpm@linux-foundation.org> <20090429195357.GB17021@elte.hu> <20090429204730.GA24298@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090429204730.GA24298@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 30 Apr 2009 10:01:00.0997 (UTC) FILETIME=[90D6F750:01C9C97A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 29, 2009 at 10:47:30PM +0200, Ingo Molnar wrote:

[..]

> What i point out below is precisely what you say is ineligible 
> under:
> 
> > > Of course, we don't have to use StinkyIdentifiers anywhere else.  
> 
> I'd extend that rule to say that StinkyIdentifiers should only be 
> used for hw API definitions/constants - macros, enums - not really 
> local variable names. The moment they are allowed into local 
> variables the stuff below happens.

to agree with Andrew, at a certain point in time I thought that having
the same register bit names as in the docs would be preferential when
you look at the docs and what the code does. But Ingo's also quite
right: we can't have "normal kernel coding style" and StinkyIdentifiers
:) in the same source file.

/me locking himself back in the patch creation basement.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

