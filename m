Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYDTOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYDTOsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYDTOsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:48:05 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:43400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYDTOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:48:04 -0400
Date: Sun, 20 Apr 2008 07:47:56 -0700 (PDT)
From: Dave Olson <dave.olson@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
cc: Ingo Molnar <mingo@elte.hu>, Ralph Campbell <ralph.campbell@qlogic.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
In-Reply-To: <adafxthbz8p.fsf@cisco.com>
Message-ID: <alpine.LFD.1.00.0804200746310.6811@topaz.pathscale.com>
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu> <adaod86aq9j.fsf@cisco.com> <alpine.LFD.1.00.0804190817280.21302@topaz.pathscale.com> <adafxthbz8p.fsf@cisco.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 20 Apr 2008 14:48:01.0907 (UTC) FILETIME=[88650C30:01C8A2F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Roland Dreier wrote:
| Not sure I really follow this response... ipath_driver.c has
| 
| 	case PCI_DEVICE_ID_INFINIPATH_7220:
| #ifndef CONFIG_PCI_MSI
| 		ipath_dbg("CONFIG_PCI_MSI is not enabled, "
| 			  "using IntX for unit %u\n", dd->ipath_unit);
| #endif
| 		ipath_init_iba7220_funcs(dd);
| 		break;
| 
| so clearly ipath_init_iba7220_funcs() was intended to be built and used
| even if CONFIG_PCI_MSI was not defined.  From the code it looks like all
| should work fine if PCI_MSI is not set, so I don't know what you mean
| about conditional checks.

Actually, it wasn't.  It was a late cleanup for another problem, and
we didn't worry about the other issue, and should have.

| (BTW since I'm looking at this code, "IntX" should probably be
| capitalized as "INTx" to match what the PCI specs say)

True.

Dave Olson
dave.olson@qlogic.com
