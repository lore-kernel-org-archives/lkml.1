Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbXEIRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbXEIRId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXEIRH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:07:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40781 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757036AbXEIRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:07:57 -0400
Date: Wed, 9 May 2007 10:07:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - Kconfig horkage
In-Reply-To: <5713.1178722647@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0705091007050.28520@schroedinger.engr.sgi.com>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
 <5713.1178722647@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 May 2007, Valdis.Kletnieks@vt.edu wrote:

> On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 
> 1) Spotted in init/Kconfig:
> 
> config SLUB_DEBUG
>         default y
>         bool "Enable SLUB debugging support" if EMBEDDED
>         help
> 
> Shouldn't that have an 'default SLUB' or 'if SLUB' or something attached to it?

Maybe. Is there a problem with SLUB_DEBUG being set if SLUB is not 
selected?

