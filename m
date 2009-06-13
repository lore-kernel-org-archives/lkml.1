Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZFMMfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZFMMfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZFMMfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:35:10 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:41654 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZFMMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u5665x7SMpANn65MNKcHT27IB+wxeZjRo4/Pb64wqvHP6I0tgUeiulrqbEvtulRGj+
         BJeknQ7fB7FqDdA+7hlh0bqkxctGdOl556Vli3IO/bzKHPOaN7K+y8VYWP8CYwP07Rr7
         KbutuRhK0e0dcOLclAix4ImcDmwz5m3ji3bR4=
Date: Sat, 13 Jun 2009 14:35:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] perfcounters: Print the filename:line for
	annotated colored lines
Message-ID: <20090613123505.GA4895@nowhere>
References: <1244844682-12928-1-git-send-email-fweisbec@gmail.com> <20090613111248.GA1355@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090613111248.GA1355@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 01:12:48PM +0200, Ingo Molnar wrote:
> 
> hm, -l doesnt work so well if a user-space binary (in this case the 
> 'git' binary of the Git project) is profiled:


Oops, sorry. Would you prefer the fix as a delta or..?

Thanks,
Frederic.


> 
> aldebaran:~/git> perf record -f ./git gc
> Counting objects: 1148, done.
> Delta compression using up to 16 threads.
> Compressing objects: 100% (450/450), done.
> Writing objects: 100% (1148/1148), done.
> Total 1148 (delta 690), reused 1148 (delta 690)
> [ perf record: Captured and wrote 1.649 MB perf.data (~72032 samples) ]
> 
> aldebaran:~/git> perf annotate -l lookup_object
> 
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> addr2line: 'vmlinux': No such file
> 
> ------------------------------------------------
>  Percent |      Source code & Disassembly of /home/mingo/git/git-update-server-info
> ------------------------------------------------
>          :
>          :      /home/mingo/git/git-update-server-info:     file format elf64-x86-64
>          :
>          :
>          :      Disassembly of section .text:
>          :
>          :      00000000004160f0 <lookup_object>:
>          :              memcpy(&i, sha1, sizeof(unsigned int));
>          :              return (int)(i % obj_hash_size);
>          :      }
> 
> 	Ingo

