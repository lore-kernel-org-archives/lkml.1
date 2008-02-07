Return-Path: <linux-kernel-owner+w=401wt.eu-S934682AbYBGVeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbYBGVeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbYBGVd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:33:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:39999 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586AbYBGVd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:33:58 -0500
Subject: Re: Xilinx: hwicap driver comments
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47AB7813.7050807@gmail.com>
References: <47AB6552.7040503@gmail.com> <1202419066.7079.130.camel@pasglop>
	 <47AB7813.7050807@gmail.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 08:33:36 +1100
Message-Id: <1202420016.7079.138.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 22:28 +0100, Jiri Slaby wrote:
> On 02/07/2008 10:17 PM, Benjamin Herrenschmidt wrote:
> > On Thu, 2008-02-07 at 21:08 +0100, Jiri Slaby wrote:
> >> - io resources are at least ulong
> > 
> > They should actually be resource_size_t :-)
> 
> Yup, should... [I don't know how ofter people have 64bit resources on 32 bit 
> this becomes a problem.]

For MMIO it's becoming more and more common actually in the embedded
space. Xilinx uses 405 cores which I think still only have a 32 bits
physical bus though, but if they ever extend it or switch to 440 they'll
have a 36 bits bus.

Ben.

