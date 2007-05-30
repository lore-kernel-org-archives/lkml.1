Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXE3Vmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXE3Vmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbXE3Vmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:42:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52720 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753731AbXE3Vmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:42:43 -0400
Date: Wed, 30 May 2007 14:42:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: Re: [PATCH 1/3] hexdump: more output formatting
In-Reply-To: <20070530143428.2f20446a.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705301439520.3358@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
 <20070523153730.e0e9e91d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
 <20070524073131.GA17501@elte.hu> <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
 <20070524142908.f39f42ea.akpm@linux-foundation.org>
 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
 <20070530143428.2f20446a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Randy Dunlap wrote:

> Add an "ascii" output parameter.  This causes ASCII data output
> following the hex data output.

The ascii output is not properly aligned. Its simply thrown in
after the hex dump output. The last line of a multi line hexdump
will have the ascii output moved to the left. Its not properly adjusted.

> + *
>   * E.g.:
>   *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);

^^^ needs to be updated?

