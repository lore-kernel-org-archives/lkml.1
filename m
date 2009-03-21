Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZCUNsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZCUNsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 09:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZCUNsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 09:48:13 -0400
Received: from hera.cwi.nl ([192.16.191.8]:42239 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZCUNsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 09:48:12 -0400
Date: Sat, 21 Mar 2009 14:47:31 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: ATA support for 4k sector size
Message-ID: <20090321134726.GA29916@ub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ha, a discussion about partitions and disk geometry.

Greg Freemyer wrote: 
> If the reported geometry of these drives was changed to have sectors /
> track be a multiple of 8, wouldn't that fix most of the issues.

It is almost twenty years ago that disks stopped having a geometry.
The ATA standard tells disks over 8 GB to report their geometry as
16383/16/63. That is, there is no information in what is reported.
It is just a constant to satisfy ancient software.

Andries

