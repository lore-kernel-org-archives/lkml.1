Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZFPUuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZFPUuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFPUuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:50:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZFPUuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:50:00 -0400
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module
 for 2.6.30
From: Eric Paris <eparis@redhat.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "\"dds" =?UTF-8?Q?=28=E2=98=95=29=22?= <dds@google.com>,
       seiji.munetoh@gmail.com, tpmdd-devel@lists.sourceforge.net,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shahbaz Khan <shaz.linux@gmail.com>
In-Reply-To: <4A36C04B.6070204@linux.vnet.ibm.com>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
	 <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
	 <4A3474BD.4000804@linux.vnet.ibm.com>
	 <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
	 <1245007238.10712.5.camel@blackbox>
	 <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>
	 <4A367093.6010206@linux.vnet.ibm.com> <4A36C04B.6070204@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 16:49:51 -0400
Message-Id: <1245185391.2848.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 18:42 -0300, Rajiv Andrade wrote:
> > 2- Forget manufacturer_id and base the decision on the PNP_ID as david
> > suggested. I previously considered it but since it would end up in
> > modifying tpm_tis_init() prototype (struct device * to struct pnp_dev *)
> > and then wouldn't work when loading as a module with force option on, so
> > I moved to the manufacturer_id approach.
> >
> > I'll get back to #2 meanwhile and post the patch, seems not hard to
> > accomplish though..
> >   
> Yes, it wasn't hard, at all, just get the id with to_pnp_dev(dev)->id.
> 
> However, the chip is buggy, there's no reason to make a compliant
> upstream code modify its behavior just due an 'exception' for a not
> compliant hardware.
> No need to worry about it too though, the workaround is available as I
> pointed earlier (Seiji's)...

Wait what?  we refuse to work around buggy hardware that is shipping in
LOTS of hardware (all the currently shipping lenovo thinkpads) even
though the fix is easy?  This doesn't sound right.....

-Eric

