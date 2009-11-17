Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZKQOfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZKQOfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZKQOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:35:43 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:36935 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZKQOfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:35:42 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 09:35:42 EST
X-Spam-Processed: digidescorp.com, Tue, 17 Nov 2009 08:27:57 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1572194246=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix pfn_valid() for noMMU
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@snapgear.com>
In-Reply-To: <20091116141426.9fc63622.akpm@linux-foundation.org>
References: <1258150109-6884-1-git-send-email-steve@digidescorp.com>
	 <20091116141426.9fc63622.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Tue, 17 Nov 2009 08:27:54 -0600
Message-Id: <1258468075.2971.6.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 14:14 -0800, Andrew Morton wrote:
> On Fri, 13 Nov 2009 16:08:29 -0600
> steve@digidescorp.com wrote:
> 
> > Configuring DEBUG_SLAB causes a noMMU kernel to die during initialization
> > with an invalid virtual address panic in kfree_debugcheck().
> > The panic is due to an improper definition of pfn_valid().
> > 
> > ...
> Is arch/score/include/asm/page.h buggy also?
> 

I don't believe so, but only because MEMORY_START is defined as zero for
that arch, making min_low_pfn zero.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


