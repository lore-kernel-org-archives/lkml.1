Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZBQIP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZBQIP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZBQIPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:15:16 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:36151 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZBQIPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:15:15 -0500
Date: Tue, 17 Feb 2009 09:15:03 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: "elf core dump: fix get_user use" breaks mips compilation
Message-ID: <20090217081503.GJ2495@deprecation.cyrius.com>
References: <20090216120136.GA9057@deprecation.cyrius.com> <20090216212515.B62C5FC3E4@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216212515.B62C5FC3E4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath <roland@redhat.com> [2009-02-16 13:25]:
> I imagine this would work around it:
> 
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1211,7 +1211,7 @@ static unsigned long vma_dump_size(struc
>  	if (FILTER(ELF_HEADERS) &&
>  	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
>  		u32 __user *header = (u32 __user *) vma->vm_start;
> -		u32 word;
> +		u32 word = 0;

Tested-by: Martin Michlmayr <tbm@cyrius.com>

-- 
Martin Michlmayr
http://www.cyrius.com/
