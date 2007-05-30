Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbXE3WSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbXE3WSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXE3WSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:18:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53660 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756012AbXE3WSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:18:08 -0400
Date: Wed, 30 May 2007 15:18:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: Re: [PATCH 1/3] hexdump: more output formatting
In-Reply-To: <a781481a0705301511p69387b2ep754c8c754ba09f36@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705301515290.14642@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com> 
 <20070524073131.GA17501@elte.hu>  <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
  <20070524142908.f39f42ea.akpm@linux-foundation.org> 
 <20070524145517.1f32cd94.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com> 
 <20070530143428.2f20446a.randy.dunlap@oracle.com> 
 <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com> 
 <465DF49B.7040100@oracle.com> <a781481a0705301511p69387b2ep754c8c754ba09f36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Satyam Sharma wrote:

> Yes, you're right, but I was just wondering whether any users really
> cared enough about the rowsize and groupsize, also seeing that
> accommodating these two args leads to a lot of increase in code.

Have two functions

1. A function that prints full lines with address and ascii
	This defaults to 16 bytes by default + ascii.

hex_dump?

2. A function to convert a few bytes for use in other output.

sprint_hex?
