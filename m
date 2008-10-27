Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYJ0AMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYJ0AMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYJ0ALv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:11:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:44274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0ALu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:11:50 -0400
Date: Sun, 26 Oct 2008 17:12:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT and MTRRs
Message-ID: <20081026171210.7b3b096a@infradead.org>
In-Reply-To: <200810262246.21807.dvadell@linuxclusters.com.ar>
References: <200810262246.21807.dvadell@linuxclusters.com.ar>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 22:46:21 -0100
"Diego M. Vadell" <dvadell@linuxclusters.com.ar> wrote:

> Hello,
> 
>    I have 6 identical PCs (HPC cluster) with MTRR problems. In older
> kernels, I had to use "mem=3300M", or else, I would get a very slowly
> boot (as when you run out of MTRRs). 
> 
>    So I thought that PAT would make this lack of MTRRs problem go
> away, and upgraded to 2.6.26.6 and 2.6.27.2, but it didn't: I still
> get (from dmesg)
> 
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 704MB
> of RAM.
> 
>    Most probably, I understood wrong. I read lwn.net's article [1]
> about PAT several times, Documentation/x86/pat.txt , tried to use
> mtrr_chunk_size= and mtrr_gran_size= in various combinations (as
> discussed in this LKML thread [2]), but I still don't get it.
> 
>    So, what did I miss? Am I wrong thinking that PAT is a better MTRR
> (wrt setting the cache type of the RAM)? 
> 

PAT can't make memory cachable that the MTRR's have as uncachable.
What PAT *can* do is, within an MTRR, do fine grained mapping...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
