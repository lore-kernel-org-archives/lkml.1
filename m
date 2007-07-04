Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbXGDKq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbXGDKq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbXGDKqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:46:18 -0400
Received: from ozlabs.org ([203.10.76.45]:44428 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759973AbXGDKqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:46:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.31346.806801.871454@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 20:46:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041208.40735.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707041039.30015.oliver@neukum.org>
	<18059.26259.765791.62319@cargo.ozlabs.ibm.com>
	<200707041208.40735.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> You cannot simply restart the URB without thinking.
> The device after resumption may or may not be in the stage
> you left it. It needs to be rechecked and some settings must be
> renewed. You cannot simple throw an URB from an arbitrary
> stage of the protocol at it.
> Suspension of devices can only happen at some points
> in the protocol.

Yeah, and?

I said "the higher-level driver needs to do the sensible thing".

Paul.
