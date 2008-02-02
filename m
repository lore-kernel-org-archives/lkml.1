Return-Path: <linux-kernel-owner+w=401wt.eu-S1763240AbYBBBa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763240AbYBBBa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbYBBBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:30:18 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38808 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758107AbYBBBaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:30:16 -0500
Date: Fri, 1 Feb 2008 17:30:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Justin M. Forbes" <jmforbes@linuxtx.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are
 remaining in quicklist 0
In-Reply-To: <1201915720.3781.18.camel@turion.linuxtx.org>
Message-ID: <Pine.LNX.4.64.0802011729560.21840@schroedinger.engr.sgi.com>
References: <20080202001232.472591439@mini.kroah.org>  <20080202002103.GW8368@suse.de>
  <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
 <1201915720.3781.18.camel@turion.linuxtx.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Justin M. Forbes wrote:

> 
> On Fri, 2008-02-01 at 16:39 -0800, Christoph Lameter wrote:
> > NO! Wrong fix. Was dropped from mainline.
> 
> What is the right fix for the OOM issues with 2.6.22? Perhaps
> http://marc.info/?l=linux-mm&m=119973653803451&w=2 should be added to
> the queue in its place?  The OOM issue in 2.6.22 is real, and should be
> addressed.

Indeed that is the right fix.

