Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZF2PxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZF2PxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbZF2PxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:53:02 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:65348 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbZF2PxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <4A4884D6.3090404@monstr.eu>
References: <4A4884D6.3090404@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 29 Jun 2009 09:52:44 -0600
Message-ID: <fa686aa40906290852g42f55390tae7148e08fb8efe3@mail.gmail.com>
Subject: Re: Move of_node_to_nid to generic location
To: monstr@monstr.eu
Cc: Arnd Bergmann <arnd@arndb.de>, benh@kernel.crashing.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 3:09 AM, Michal Simek<monstr@monstr.eu> wrote:
> Hi All,
>
> I have on my list one task which needs to be discuss with you.
> I look at of_node_to_nid for non NUMA systems. I think we should
> move this function to asm-generic/topology.h.

I'm in the process of moving a bunch of stuff out of the various
prom.c files and into drivers/of/*.c.  If this is a common function,
then I think it should go there.

> This function is used for powerpc, sparc, microblaze (and maybe future arm?)

PowerPC uses it.  Other than that I don't know.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
