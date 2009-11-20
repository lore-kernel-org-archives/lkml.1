Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZKTUX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZKTUX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZKTUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:23:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35875 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbZKTUXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:23:52 -0500
MIME-Version: 1.0
In-Reply-To: <20091120095622.5fefb9fa.sfr@canb.auug.org.au>
References: <20091120095622.5fefb9fa.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 20 Nov 2009 13:23:39 -0700
X-Google-Sender-Auth: 4a1df1661e9467e1
Message-ID: <fa686aa40911201223t1d82f43an3f52fa2599088d3b@mail.gmail.com>
Subject: Re: linux-next: microblaze tree build failure
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Simek <michal.simek@petalogix.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 3:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Michal,
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>
> arch/powerpc/platforms/built-in.o: In function `.ofdt_write':
> reconfig.c:(.text+0xca08): undefined reference to `.of_attach_node'
> arch/powerpc/platforms/built-in.o: In function `.do_device_node':
> vio.c:(.text+0x1be2c): undefined reference to `.of_attach_node'
>
> Caused by commit 5d0c1c076548e1f8d590a2f70f281b4eb7b3aeb2 ("Merge
> of_attach_node") which I have reverted for today.  That patch is missing
> an update to drivers/of/Makefile at least ... and probably some other
> stuff as well.

... and the OF changes shouldn't be going through the microblaze tree.
 This looks like it was an accident.  Michal?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
