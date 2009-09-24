Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZIXSIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZIXSIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZIXSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:08:29 -0400
Received: from hq-exedge.brocade.com ([66.243.153.82]:38796 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZIXSI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:08:29 -0400
From: Jing Huang <huangj@Brocade.COM>
To: Daniel Walker <dwalker@fifo99.com>
CC: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       Krishna Gudipati <kgudipat@Brocade.COM>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
Date: Thu, 24 Sep 2009 11:08:31 -0700
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Thread-Topic: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Thread-Index: Aco9QFmTX7joZ+N7QLK/wPqxkNcvkAAALQkw
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F79B@HQ-EXCH-7.corp.brocade.com>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	 <1253807042.20648.188.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
 <1253814934.20648.262.camel@desktop>
In-Reply-To: <1253814934.20648.262.camel@desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Daniel,
> >
> > I did run checkpatch.pl and it didn't report any ERROR or WARNING. Do
> you use any specific flags?
> 
> No nothing special .. I run it in the following way,
> 
> ./scripts/checkpatch.pl this-is-the-test.patch
> 
> or
> 
> cat this-is-the-test.patch | ./scripts/checkpatch.pl -
> 
> how did you run it? Usually it will report something like the following
> if it finds nothing,
> 
> total: 0 errors, 0 warnings, XXX lines checked
> 
> Your patch has no obvious style problems and is ready for submission.
> 
> 
> 
> Daniel

Thanks. I found the problem. I tried the latest checkpatch in 2.6.31 and it generates a lot of ERRORs about putting parentheses for return. I have been using an older version of checkpatch for patch submission all the time, and therefore I didn't see any problem. I will fix them and resubmit the patch.

Jing 

