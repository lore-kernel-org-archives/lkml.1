Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYJAWib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYJAWib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYJAWiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:38:18 -0400
Received: from gw.goop.org ([64.81.55.164]:57198 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbYJAWiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:38:16 -0400
Message-ID: <48E3FBCE.8030103@goop.org>
Date: Wed, 01 Oct 2008 15:38:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to make all of 4GB of memory available?
References: <200810011417.00595.gene.heskett@gmail.com>
In-Reply-To: <200810011417.00595.gene.heskett@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
>
> New mobo, 4 core AMD Phenom cpu & 4 GB of dram.  I cannot find the switch in a 
> make xconfig that will allow use of all of it, I am only seeing 3GB.
>
> Am I going blind in my dotage?

Does it all appear in the e820 map?  If not, then the chipset is 
probably masking it; check to see if there's any likely-looking BIOS 
options to make it appear.

I assume you're compiling for either 32-bit PAE or 64-bit.  If you're 
compiling 32-bit without PAE (HIGHMEM64G) then the remaining Gbyte may 
simply be above 4G and out of the kernel's reach.

    J
