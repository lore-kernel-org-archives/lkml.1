Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbXGJU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbXGJU7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbXGJU7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:59:06 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:45974 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145AbXGJU7E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:59:04 -0400
Date: Tue, 10 Jul 2007 16:59:01 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Martin Bligh <mbligh@mbligh.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       "Alexandre =?iso-8859-1?Q?Gu=E9don?=" 
	<totalworlddomination@gmail.com>
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality, performance and maintenance
Message-ID: <20070710205901.GA19805@Krystal>
References: <p73y7hrywel.fsf@bingen.suse.de> <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com> <46925B5D.8000507@google.com> <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com> <4692A1D0.50308@mbligh.org> <20070709214426.GC1026@Krystal> <Pine.LNX.4.64.0707091451200.18780@schroedinger.engr.sgi.com> <20070709225817.GA5111@Krystal> <Pine.LNX.4.64.0707091715450.2062@schroedinger.engr.sgi.com> <20070710082709.GC16148@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070710082709.GC16148@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:52:08 up 3 days, 10:57,  4 users,  load average: 0.90, 0.35, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another architecture tested

Comparison: irq enable/disable vs local CMPXCHG
             enable interrupts (STI)   disable interrupts (CLI)    local CMPXCHG
Tested-by: Mathieu Desnoyers <compudj@krystal.dyndns.org>
IA32 (P4)               112                        82                       26
x86_64 AMD64            125                       102                       19
Tested-by: Alexandre Guédon <totalworlddomination@gmail.com>
x86_64 Intel Core2 Quad  21                        19                        7


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
