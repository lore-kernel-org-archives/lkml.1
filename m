Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYESNpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYESNpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYESNpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:45:41 -0400
Received: from main.gmane.org ([80.91.229.2]:43149 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857AbYESNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:45:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Date: Mon, 19 May 2008 13:45:29 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <g0s09p$o7h$1@ger.gmane.org>
References: <48313E08.8070904@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 10:44:56 +0200, Peter Oberparleiter wrote:

> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Change all source and include paths to absolute form when
> CONFIG_GCOV_PROFILE is enabled.
> 
> Example:
> 
>   gcc -Idir1 -c a.c -o a.o
> 
> will become
> 
>   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
> 
> Required by the gcov profiling infrastructure: when compiling with
> option -fprofile-arcs, gcc stores file names inside object files.
> Relative paths prevent the gcov tool from finding corresponding source
> files.

I think it would be good to fix this in the gcov tool. When I think
of distribution kernels the source usually ends up in a different
place in the packages than the kernel was originally compiled. So
it would be good to extend gcov here or let it search in well known
locations first (/usr/src/linux, /usr/src/debug/...).

Cheers,
Jan

