Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYGGSfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYGGSfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYGGSfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:35:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395AbYGGSfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:35:18 -0400
Date: Mon, 7 Jul 2008 11:34:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: *sigh* /proc/*/pagemap
In-Reply-To: <1215454997.11311.165.camel@calx>
Message-ID: <alpine.LFD.1.10.0807071130540.11076@woody.linux-foundation.org>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>  <20080704185312.052e7145.akpm@linux-foundation.org>  <alpine.LFD.1.10.0807051036000.2815@woody.linux-foundation.org> <1215454997.11311.165.camel@calx>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Matt Mackall wrote:
> 
> It exists to make the VM stop being a big black box. Before now the VM
> exposed little beyond statistics, many of which are basically
> meaningless (RSS?). With pagemap, you can actually see precisely where
> things are getting allocated, how they're getting shared, etc. Think
> NUMA, think cell phones.

Umm. How about setting it under CONFIG_DEBUG_VM or something like that 
then?

Right now it's not even _asked_ about, unless you're EMBEDDED, and 
defaults to 'y'. Which means that it has all the downsides, an none of the 
upsides, for 99.99% of all users.

			Linus
