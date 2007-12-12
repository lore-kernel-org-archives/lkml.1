Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXLLSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXLLSqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbXLLSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:46:26 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:59588 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759053AbXLLSqY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:46:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22.14 oops msg with commvault galaxy ?
Date: Wed, 12 Dec 2007 13:45:57 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071212134158.GA5547@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22.14 oops msg with commvault galaxy ?
Thread-Index: Acg8xOVnZtZnT4+OQjC4m2HO0uNFVQAKeBrg
References: <20071211164319.GA14783@linux.vnet.ibm.com> <20071211170400.GA4861@suse.de> <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071212134158.GA5547@linux.vnet.ibm.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Greg KH" <gregkh@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>, <kay.sievers@vrfy.org>,
       "Balbir Singh" <balbir@in.ibm.com>, <maneesh@in.ibm.com>
X-OriginalArrivalTime: 12 Dec 2007 18:45:58.0910 (UTC) FILETIME=[3C7351E0:01C83CEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Dhaval Giani
> 
> On Wed, Dec 12, 2007 at 07:57:33AM -0500, Fortier,Vincent 
> [Montreal] wrote:
> > > -----Message d'origine-----
> > > De : Dhaval Giani [mailto:dhaval@linux.vnet.ibm.com]
> > > 
> > > On Tue, Dec 11, 2007 at 10:06:53PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Fortier,Vincent [Montreal] <Vincent.Fortier1@EC.GC.CA> wrote:
> > > > 
> > > > > > That has changed from /sys/kernel/uids/<uid>/cpu_share
> > > > > 
> > > > > Here is my config.
> > > > > 
> > > > > Maybie I should give it a shot without CFS at all and see what

> > > > > happends ?
> > 
> > It got triggerred also using a 2.6.22.14:

Here are my preliminary test results:
       2.6.21.7: OK
   2.6.22.13/14: Failure
       2.6.23.9: OK
2.6.24-rc5-git2: OK

It seems to only hang using a 2.6.22 kernel.

> 
> No, not any more. Would it be possible for you to do a 
> git-bisect? I am not too well versed with sysfs, so it is not 
> apparent to me what is causing this oops. It seems to be 
> easily reproducible. I don't still have a reliable method to 
> reproduce it without the CFS patch. Could sysfs experts 
> please help debugging?
> 

I seriously doubt I have the time to do a git-bisect at the moment....

- vin
