Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZIVHPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZIVHPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZIVHO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:14:59 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28760 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZIVHO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:14:58 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R1453M98dN936eMzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQD2SO-01-5PJ-02
X-M-MSG: 
Date: Tue, 22 Sep 2009 09:14:49 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Keith Mannthey <kmannth@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
Message-ID: <20090922071449.GA25479@aftab>
References: <1253239781.7263.113.camel@keith-laptop>
 <20090918144226.GD25309@aftab>
 <1253294933.7263.129.camel@keith-laptop>
 <20090921145502.GC23580@aftab>
 <1253577024.7263.196.camel@keith-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253577024.7263.196.camel@keith-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Sep 2009 07:14:41.0882 (UTC) FILETIME=[5AB89BA0:01CA3B54]
X-Reverse-DNS: ausb3extmailp02.amd.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 04:50:24PM -0700, Keith Mannthey wrote:
> On Mon, 2009-09-21 at 16:55 +0200, Borislav Petkov wrote:
> > Hi Keith,
> > 
> > On Fri, Sep 18, 2009 at 10:28:53AM -0700, Keith Mannthey wrote:
> > > > By the way, your patches made me look harder at that code region and
> > > > I've found some more problems with it which I've fixed. Would you like
> > > > to test the whole bunch of fixes on your setup?
> > > 
> > > Yes please send any changes you have.  I have a decent test setup for
> > > live errors. 
> > 
> > The patch queue is at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git
> > 
> > the 'edac-fixes' branch.
> 
> Please check you have synced with that git tree.  When I pull the tree
> it is 2.6.30-rc5 without the amd64_edac driver.  It has no branch
> outside of "master". 

This happens because it is a bare repository without a working tree.
You'll have to add it as a remote repository to an already existing
(with a working tree) one you have locally like so:

(in your repository do:)

git remote add edac git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git

git fetch edac

git checkout -b edac-test edac/edac-fixes

Now you should be on the branch with the patchset.

Let me know how it goes.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

