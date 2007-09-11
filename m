Return-Path: <linux-kernel-owner+w=401wt.eu-S966874AbXIKG0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966874AbXIKG0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966010AbXIKGJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:09:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33809 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966002AbXIKGI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:08:58 -0400
Date: Tue, 11 Sep 2007 11:39:13 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] Add extended crashkernel command line syntax
Message-ID: <20070911060913.GC5053@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070909083914.065380136@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909083914.065380136@strauss.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:39:14AM +0200, Bernhard Walle wrote:
> This patch adds a extended crashkernel syntax that makes the value of reserved
> system RAM dependent on the system RAM itself:
> 
>     crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
>     range=start-[end]
> 
> For example:
> 
>     crashkernel=512M-2G:64M,2G-:128M
> 
> The motivation comes from distributors that configure their crashkernel command
> line automatically with some configuration tool (YaST, you know ;)). Of course
> that tool knows the value of System RAM, but if the user removes RAM, then
> the system becomes unbootable or at least unusable and error handling
> is very difficult.
> 

System does not boot after removing memory because a large chunk of it has
been reserved by kdump and there is not sufficient memory left for rest of
the OS to initialize?

How often does this scenario happen? Anyway, if you run into these issues
and if it helps, I don't mind additional command line syntax for crashkernel=
 
> This series implements this change for i386, x86_64 and IA64. However, if
> the patch is accepted, I can also add all other architectures that support
> Kdump (when my grepping was correct, this is only PPC64 and SH in addition).
> The "simple" syntax is of course still supported.
> 
> 

Please make the changes for ppc64 and sh too.

Thanks
Vivek
