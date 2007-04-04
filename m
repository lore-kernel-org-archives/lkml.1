Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbXDDRgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbXDDRgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXDDRft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:35:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38422 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbXDDRfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:35:32 -0400
Date: Wed, 4 Apr 2007 10:35:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB powerpc)
In-Reply-To: <1175708002.6185.29.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704041034270.26866@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com> 
 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com> 
 <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041003170.24640@schroedinger.engr.sgi.com>
 <1175708002.6185.29.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Badari Pulavarty wrote:

> Next issue ? Sorry.

No problem. Could have a look at the hvsi driver and figure out what is 
failing there? What is the hvsi driver?

> Console: switching to colour frame buffer device 80x30
> fb0: MATROX frame buffer device
> matroxfb_crtc2: secondary head of fb0 was registered as fb1
> Kernel panic - not syncing: Couldn't register hvsi console driver

Framebuffer allocation failure????

