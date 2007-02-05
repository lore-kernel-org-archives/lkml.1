Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbXBEMge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbXBEMge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXBEMge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:36:34 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:40656 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206AbXBEMgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:36:33 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Mon, 5 Feb 2007 13:36:11 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: logic@thinknet.ro
cc: linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20070205123611.GI8804@amd.com>
References: <1131.86.55.168.2.1170690089.squirrel@mail.thinknet.ro>
MIME-Version: 1.0
In-Reply-To: <1131.86.55.168.2.1170690089.squirrel@mail.thinknet.ro>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Feb 2007 12:36:14.0453 (UTC)
 FILETIME=[396D5250:01C74922]
X-WSS-ID: 69D9FB421WC6056033-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:41:29PM +0200, logic@thinknet.ro wrote:
> Good morning,
> 
> I am experiencing a bug i think. I am running a 2.6.19.2 kernel on a 3Ghz
> Intel with HT activated, 1 gb ram, and noname motherboard. Here is the
> output of the hang:

Hmm, this seems to be the same issue as in [1] and [2]. A page that is
assumed to belong to the slab but is not longer marked as a slab page.
Could this be a bug in the memory management?

Joerg

[1] http://lkml.org/lkml/2007/2/4/77
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=406477

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


