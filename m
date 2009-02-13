Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbZBME1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbZBME1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZBME1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:27:44 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64723 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbZBME1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:27:44 -0500
Date: Thu, 12 Feb 2009 23:27:31 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Jon Masters <jonathan@jonmasters.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Jeff Arnold <jbarnold@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [PATCH 6/9] Ksplice: Add functions for walking kallsyms
 symbols
In-Reply-To: <1234420667.22036.26.camel@perihelion.bos.jonmasters.org>
Message-ID: <alpine.DEB.2.00.0902120143240.27436@vinegar-pot.mit.edu>
References: <20090207124645.467A2DDDDF@ozlabs.org>  <1234383595.4324.42.camel@jcmlaptop>  <alpine.DEB.2.00.0902111550520.27436@vinegar-pot.mit.edu> <1234420667.22036.26.camel@perihelion.bos.jonmasters.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Jon Masters wrote:

> Ah thanks, I didn't realize you were proposing for mainline merge -
> awesome. That would really be a useful merge...how close do you think
> that is?

I don't know when it will be merged, but I can comment on the status of 
our patches.

Ksplice has essentially two prerequisite changes:

- Changes to the module subsystem.  Rusty Russell included versions of 
those patches in a recent patch series for the module system targeted at 
2.6.30.

- Support for building the Linux kernel with -ffunction-sections 
-fdata-sections.  Linus was asked about a week ago whether he would take 
the patch, but he has not responded yet.

As for the Ksplice core, Rusty Russell has started reading the code and 
has requested some changes to it to assist further review.  We hope to 
send a new patch series with those changes made next week.

	-Tim Abbott
