Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXHVSuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXHVSuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763590AbXHVSun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:50:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39995 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761526AbXHVSum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:50:42 -0400
Date: Wed, 22 Aug 2007 11:50:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] define have_arch_cmpxchg()
In-Reply-To: <20070822150043.GA8504@Krystal>
Message-ID: <Pine.LNX.4.64.0708221150080.13813@schroedinger.engr.sgi.com>
References: <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
 <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
 <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
 <20070822150043.GA8504@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Mathieu Desnoyers wrote:

> define have_arch_cmpxchg()

Should this not be 

	have_arch_cmpxchg_local()  ?

cmpxchg does not bring us anything.
