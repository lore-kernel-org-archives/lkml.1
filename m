Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZIXW2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZIXW2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZIXW2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:28:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55463 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbZIXW2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:28:53 -0400
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jing Huang <huangj@Brocade.COM>
Cc: Daniel Walker <dwalker@fifo99.com>,
       Krishna Gudipati <kgudipat@Brocade.COM>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
In-Reply-To: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F79B@HQ-EXCH-7.corp.brocade.com>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	 <1253807042.20648.188.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
	 <1253814934.20648.262.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F79B@HQ-EXCH-7.corp.brocade.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 22:28:51 +0000
Message-Id: <1253831331.5183.264.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 11:08 -0700, Jing Huang wrote:
> > > Hi Daniel,
> > >
> > > I did run checkpatch.pl and it didn't report any ERROR or WARNING. Do
> > you use any specific flags?
> > 
> > No nothing special .. I run it in the following way,
> > 
> > ./scripts/checkpatch.pl this-is-the-test.patch
> > 
> > or
> > 
> > cat this-is-the-test.patch | ./scripts/checkpatch.pl -
> > 
> > how did you run it? Usually it will report something like the following
> > if it finds nothing,
> > 
> > total: 0 errors, 0 warnings, XXX lines checked
> > 
> > Your patch has no obvious style problems and is ready for submission.
> > 
> > 
> > 
> > Daniel
> 
> Thanks. I found the problem. I tried the latest checkpatch in 2.6.31
> and it generates a lot of ERRORs about putting parentheses for return.
> I have been using an older version of checkpatch for patch submission
> all the time, and therefore I didn't see any problem. I will fix them
> and resubmit the patch.

Actually, could you send an incremental diff ... I'll put this in the
tree because it's about time it got wider testing in linux-next.

James


