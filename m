Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZGABUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZGABUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762473AbZGAAkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:40:45 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:27570 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762469AbZGAAkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:40:43 -0400
Date: Tue, 30 Jun 2009 17:40:46 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       tpmdd-devel@lists.sourceforge.net, seiji.munetoh@gmail.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module for 2.6.30
Message-ID: <20090701004046.GA13013@hexapodia.org>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com> <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com> <4A3474BD.4000804@linux.vnet.ibm.com> <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com> <1245007238.10712.5.camel@blackbox> <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com> <4A367093.6010206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A367093.6010206@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:02:27PM -0300, Rajiv Andrade wrote:
> Yep, sorry. Two options:
> 
> 1- Inside that check, if got an error when in that particular
> tpm_getcap() stacked call, consider that it might be this iTPM, and
> bypass it just to get the value from the chip (would happen only once) -
> Would work, but it's odd.
> 
> 2- Forget manufacturer_id and base the decision on the PNP_ID as david
> suggested. I previously considered it but since it would end up in
> modifying tpm_tis_init() prototype (struct device * to struct pnp_dev *)
> and then wouldn't work when loading as a module with force option on, so
> I moved to the manufacturer_id approach.
> 
> I'll get back to #2 meanwhile and post the patch, seems not hard to
> accomplish though..

I've got a set of patches that seem to resolve my iTPM woes.  I've
mostly tested on T400 but I also tried X200.

I'll send the patches as a separate thread (unfortunately I can't get
git-send-email 1.6.3.1 to set a in-reply-to header on 0/5 without also
breaking threading on x/5.)

-andy
