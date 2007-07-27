Return-Path: <linux-kernel-owner+w=401wt.eu-S936158AbXG0LAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936158AbXG0LAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXG0LAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:00:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45571 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbXG0LAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:00:05 -0400
Date: Fri, 27 Jul 2007 13:01:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, general@lists.openfabrics.org,
       raisch@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [PATCH 1/2] ehca: remove checkpatch.pl's warnings "externs should be avoided in .c files"
Message-ID: <20070727110118.GB12647@uranus.ravnborg.org>
References: <200707271254.51055.hnguyen@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707271254.51055.hnguyen@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 12:54:50PM +0200, Hoang-Nam Nguyen wrote:
> >From b5d0336089b5ebe5b18acb94b2c94c2026cb95ee Mon Sep 17 00:00:00 2001
> From: Hoang-Nam Nguyen <hnguyen at de.ibm.com>
> Date: Fri, 27 Jul 2007 10:24:49 +0200
> Subject: [PATCH] remove checkpatch.pl's warnings "externs should be avoided in .c files"
> 
> Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

And you checked that said .h file was indeed included by the .c file that has the original definition?
Otherwise the definition and the declaration can get out of sync without notice.

	Sam
