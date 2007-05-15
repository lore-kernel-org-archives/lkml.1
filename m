Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbXEOUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbXEOUqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbXEOUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:45:55 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39074
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbXEOUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:45:54 -0400
From: Rob Landley <rob@landley.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Date: Tue, 15 May 2007 16:45:44 -0400
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <464158E9.2000207@zytor.com> <4645032E.1030109@gmail.com> <46450910.8080503@zytor.com>
In-Reply-To: <46450910.8080503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705151645.44524.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2007 8:23 pm, H. Peter Anvin wrote:
> Kevin Winchester wrote:
> > Not sure if you were looking for testing, but I fuzzed it to apply to
> > 2.6.21-git and gave it a spin.  Worked just like a normal boot (which I
> > assume was the point).
> 
> That would be the point, yes :)  Looking for breakage in video mode
> detection, memory detection, and APM are probably the trickiest areas.

This may not be the most useful datapoint, but applying the patch to 
current -git didn't give me something that qemu could boot.

I applied the patch to current -git (well, current -hg but same thing).  The 
flat patch didn't quite apply cleanly.  (Hunks in Documentation, video.S, and 
verify_cpu.S claimed to be already applied.  I told it to ignore them.)  The 
result compiled cleanly enough, but didn't boot under qemu.  (It 
said "booting from hard drive" and then hung.  No decompressing message.)  
I've confirmed that without the patch, current -hg does boot under qemu.

Awaiting the broken-out patchset mentioned earlier, with interest if not 
skill... :)

Rob
