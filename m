Return-Path: <linux-kernel-owner+w=401wt.eu-S1767655AbXEDDew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767655AbXEDDew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767652AbXEDDew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:34:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33166 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754575AbXEDDev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:34:51 -0400
Date: Thu, 3 May 2007 20:34:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
In-Reply-To: <20070503202111.667c9b14.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705032033560.16788@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
 <20070503202111.667c9b14.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Andrew Morton wrote:

> On Thu, 3 May 2007 20:08:41 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Performance tests show a slight improvements in netperf (not a
> > strong case for a performance improvement but removing the
> > constructor has definitely no negative impact so why keep
> > this around?).
> > 
> > TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost (127.0.0.1) port 0 AF_INET
> > Recv   Send    Send
> > Socket Socket  Message  Elapsed
> > Size   Size    Size     Time     Throughput
> > bytes  bytes   bytes    secs.    10^6bits/sec
> > 
> > Before:
> >  87380  16384  16384    10.01    6026.04
> >  87380  16384  16384    10.01    5992.17
> >  87380  16384  16384    10.01    6071.23
> > 
> > After:
> >  87380  16384  16384    10.01    6090.20
> >  87380  16384  16384    10.01    6078.3
> >  87380  16384  16384    10.00    6013.52
> 
> How could a filesystem change affect networking performance?
> 
> The change looks nice, but I'd microbenchmark it with a write-to-ext2-on-ramdisk
> or something like that.

Hmmmm.. I was told in another thread that this is the most frequently used 
slab for this benchmark ...... Just accepted that as true.
 
