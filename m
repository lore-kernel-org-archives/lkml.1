Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHSX3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHSX3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYHSX3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:29:35 -0400
Received: from ozlabs.org ([203.10.76.45]:46700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbYHSX3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:29:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18603.22359.447836.113347@cargo.ozlabs.ibm.com>
Date: Wed, 20 Aug 2008 09:29:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Alexander Schmidt1 <ALEXSCHM@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>, Olaf Hering <olaf@aepfle.de>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] ibmebus/of_platform: Move "name" sysfs attribute into generic
 OF devices
In-Reply-To: <OFD6515867.CFE29C04-ONC12574AA.003B8D55-C12574AA.003BB443@de.ibm.com>
References: <200808051630.19619.fenkes@de.ibm.com>
	<18602.18568.338552.482669@cargo.ozlabs.ibm.com>
	<OFD6515867.CFE29C04-ONC12574AA.003B8D55-C12574AA.003BB443@de.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joachim Fenkes writes:

> > Is this a bugfix that is needed for 2.6.27?
> 
> Yes, definitely. The eHCA userspace driver relies on the name attribute to 
> check for valid adapters (it checks that the name is "lhca"), so with the 
> name attribute gone, eHCA userspace will cease to work.

OK, I'll put it in.  Please, in future, always say explicitly if you
think a patch needs to go in to the kernel we're currently
stablizing.  Otherwise, I'll generally assume it's for the next merge
window.

Paul.
