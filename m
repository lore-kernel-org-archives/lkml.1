Return-Path: <linux-kernel-owner+w=401wt.eu-S935168AbYCEB2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935168AbYCEB2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbYCEB2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:28:42 -0500
Received: from mail.suse.de ([195.135.220.2]:32879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbYCEB2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:28:41 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: preempt bug in set_pmd_pfn?
Date: Wed, 5 Mar 2008 02:28:34 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47CDBB87.8090906@goop.org> <200803050116.46119.ak@suse.de> <47CDE718.9090302@goop.org>
In-Reply-To: <47CDE718.9090302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050228.34262.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 01:19:36 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > On Wednesday 05 March 2008 01:07:11 Jeremy Fitzhardinge wrote:
> >   
> >> Andi Kleen wrote:
> >>     
> >>>> Won't this leave a stale tlb on the old processor?
> >>>>     
> >>>>         
> >>> __set_fixmap should be only used in early boot, so it's always
> >>> on CPU 0
> >>>       
> >> vdso32-setup.c:map_compat_vdso() uses it to create the compat vdso 
> >> mapping, which typically happens on the first execve(),
> >>     
> >
> > First execve for 32bit binaries?
> >   
> 
> Yes, 32-bit kernel.

Ok I'm talking about 64bit. If you ask me something about 32bit please
always mention it especially.

> > Anyways __set_fixmap is __init and at the first  execve (unless you have initramfs) 
> > init.text should be already freed.
> 
> No, its not __init.  If it were I don't think there would have been much 
> booting going on for the last few months.

For 64bit my original statement was correct.

-Andi
