Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbXEKEhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbXEKEhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 00:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXEKEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 00:37:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49010 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbXEKEhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 00:37:46 -0400
Date: Fri, 11 May 2007 10:07:12 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Message-ID: <20070511043712.GB16944@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <464158E9.2000207@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464158E9.2000207@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:15:21PM -0700, H. Peter Anvin wrote:
> Hello all,
> 
> I believe the x86 setup tree is now finished.  I will turn it into a
> "clean patchset" later this week, but I wanted to get flamed^W feedback
> on it first.
> 
> The git tree is at:
> 
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-newsetup.git
> ...
> 
> ... and a flat patch at ...
> 
> http://www.kernel.org/pub/linux/kernel/people/hpa/newsetup-36f021b5.patch
> 

Wow, reading code in C is so much better than decoding assembly. :-)

Had a quick look, mainly from relocatable kernel code point of view. Yet
to dive deeper. 

PHYSICAL_ALIGN needs to be 2MB on x86_64 instead of 1MB.

Thanks
Vivek
