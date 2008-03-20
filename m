Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbYCTEEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbYCTEEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYCTEEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:04:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYCTEEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:04:04 -0400
Date: Wed, 19 Mar 2008 21:01:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       joe@fruitfly.org
Subject: Re: [Bugme-new] [Bug 10284] New: executables with read bit 'off'
 cannot open /dev/stdin
Message-ID: <20080319210115.02915291@laptopd505.fenrus.org>
In-Reply-To: <20080320015650.GG424@parisc-linux.org>
References: <bug-10284-10286@http.bugzilla.kernel.org/>
	<20080319143108.c8f8a544.akpm@linux-foundation.org>
	<20080320015650.GG424@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 19:56:50 -0600
Matthew Wilcox <matthew@wil.cx> wrote:


> I've tried this program on 2.6.25-rc3-00093-g59e1338-dirty and it does
> not fail.
> 
> > > open("/dev/stdin", O_RDONLY)            = -1 EACCES (Permission
> > > denied)
> 
> Specifically, my tests show:
> 
> open-stdin-readable:open("/dev/stdin", O_RDONLY)            = 3
> open-stdin-unreadable:open("/dev/stdin", O_RDONLY)            = 3
> 
> Joe, can you try a more recent kernel?

another interesting question is if you're using some special LSM/security stuff..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
