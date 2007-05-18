Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbXEROiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbXEROiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXEROis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:38:48 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:33661 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490AbXEROir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:38:47 -0400
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: rct@gherkin.frus.com
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Date: Fri, 18 May 2007 16:38:27 +0200
User-Agent: KMail/1.9.6
cc: "Andi Kleen" <ak@suse.de>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
References: <20070517233813.266B6DBA1@gherkin.frus.com>
In-Reply-To: <20070517233813.266B6DBA1@gherkin.frus.com>
MIME-Version: 1.0
Message-ID: <200705181638.29657.joachim.deguara@amd.com>
X-OriginalArrivalTime: 18 May 2007 14:38:32.0126 (UTC)
 FILETIME=[3527DDE0:01C7995A]
X-WSS-ID: 6A5365E11OC2127295-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007 01:38:13 rct@gherkin.frus.com wrote:
> Andi Kleen wrote:
> > Hmpf.
> >
> > We cold either use rdmsr_safe or add a family check again or clear it
> > in k6 setup.  I think clearing it in setup is cleanest.
> >
> > Does this patch work?
> >
> > -Andi
> >
> > Clear MCE flag on AMD K6
> >
> > It reports machine check capability in CPUID, but doesn't actually
> > implement all the necessary MSRs of the standard Intel machine
> > check architecture.
> >
> > This fixes a boot failure recently introduced.
> >
> > Signed-off-by: Andi Kleen <ak@suse.de>
>
> ACK.  I reinstalled Joachim's patch (default 2.6.22-rc1 state), and
> added your patch.  Life is good: we have a fix/workaround.

Great, thanks for finding this and Andi for the patch.  I'll talk to our labs 
about dusting off old systems for testing ;)

-Joachim


