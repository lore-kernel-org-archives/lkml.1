Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZIXRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZIXRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZIXRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:55:49 -0400
Received: from fifo99.com ([67.223.236.141]:49891 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZIXRzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:55:48 -0400
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
From: Daniel Walker <dwalker@fifo99.com>
To: Jing Huang <huangj@Brocade.COM>
Cc: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       Krishna Gudipati <kgudipat@Brocade.COM>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
In-Reply-To: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	 <1253807042.20648.188.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:55:34 -0700
Message-Id: <1253814934.20648.262.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 10:38 -0700, Jing Huang wrote:
> > On Wed, 2009-09-23 at 17:49 -0700, Jing Huang wrote:
> > > +
> > > +       return (*(union bfi_addr_u *) &addr);
> > > +}
> > 
> > Have you run checkpatch on this code? It produces many errors due to
> > your "return" usage for one.. The usual style of return is not to use
> > parentheses since it's really not a function ..
> > 
> > The line I quoted above gives the following error,
> > 
> > ERROR: return is not a function, parentheses are not required
> > #266: FILE: drivers/scsi/bfa/bfa_cb_ioim_macros.h:132:
> > +       return (*(union bfi_addr_u *) &addr);
> > 
> > First of all I'd consider making your code consistent with respect to
> > the return statements .. I noticed that you sometimes use the
> > parentheses sometimes not .. Since it's more with Linux style I'd just
> > remove all the extra parentheses..
> > 
> > Checkpatch produces many other errors in your code .. If you haven't
> > already evaluated those errors, I'd do go through each patch and review
> > the errors (and the warnings) that it produces since checkpatch can give
> > you a fairly mechanical view into how well your code matches the Linux
> > coding style. The less the output from checkpatch the better ..
> > 
> > Daniel
> > 
> 
> Hi Daniel, 
> 
> I did run checkpatch.pl and it didn't report any ERROR or WARNING. Do you use any specific flags?

No nothing special .. I run it in the following way,

./scripts/checkpatch.pl this-is-the-test.patch

or

cat this-is-the-test.patch | ./scripts/checkpatch.pl -

how did you run it? Usually it will report something like the following
if it finds nothing,

total: 0 errors, 0 warnings, XXX lines checked

Your patch has no obvious style problems and is ready for submission.



Daniel

