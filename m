Return-Path: <linux-kernel-owner+w=401wt.eu-S1764057AbZEHUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764057AbZEHUyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZEHUyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:54:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZEHUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:54:04 -0400
Message-ID: <4A049AF5.7090300@zytor.com>
Date: Fri, 08 May 2009 13:49:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com
Subject: Re: [PATCH 05/14] kbuild: allow compressors (gzip, bzip2, lzma) to
 take multiple inputs
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-6-git-send-email-hpa@linux.intel.com> <20090508074234.GD12808@uranus.ravnborg.org> <4A0493B0.3090204@linux.intel.com> <20090508204747.GA18041@uranus.ravnborg.org>
In-Reply-To: <20090508204747.GA18041@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> I did a quick attempt to integrate it in the Makefile - not pretty.
> So I dropped that idea.
> 
> It is mainly that we should not fill up scripts/ with small
> undocumented scripts.
> 
> Could you add something like this in the top of the file:
> 
> # Find the sum of the size of all files specified and
> # output the size as an escaped hex string.
> #
> # Sample:
> # $ ls -l foo
> # $ -rw-rw-r-- 1 xxx xxx 146 May  8 22:28 foo
> # $ bin_size foo
> # $ \\x92\\x00\\x00\\x00
> # 146 equals 92 hex
> 

OK, I see your point (especially since that's not what it does.)

To be honest, how ugly would it be to get a C program in here?  Doing 
this in shell is horrid, and people tend to whine about Perl (which is 
perfect for this kind of job.)

	-hpa

