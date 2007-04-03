Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXDCXkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXDCXkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXDCXkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:40:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36465 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030275AbXDCXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:40:34 -0400
Date: Tue, 3 Apr 2007 16:40:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Badari Pulavarty wrote:

> > x86_64 with numa emulation 4 nodes boots fine here.
> 
> Not sure, if this helps any (slub_debug = 1) :(

Specify only slub_debug. The 1 is not recognized by SLUB so there were no 
debug options set.

> Linux version 2.6.21-rc5-mm4 (root@elm3b29) (gcc version 4.1.0 (SUSE
> Linux)) #2 SMP Tue Apr 3 17:36:21 PDT 2007
> Command line: root=/dev/hda2 vga=0x314  selinux=0   console=tty0
> console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent
> showopts

^^^ I see no slub_debug option set.
