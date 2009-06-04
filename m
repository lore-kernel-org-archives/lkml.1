Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZFDUHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZFDUHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZFDUHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:07:40 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46822 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZFDUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:07:40 -0400
Date: Thu, 4 Jun 2009 22:09:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>
Subject: Re: [PATCH 4/6] headers_check fix: mips, ioctl.h
Message-ID: <20090604200953.GA13892@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <1244118599.5172.31.camel@ht.satnam> <1244118714.5172.33.camel@ht.satnam> <1244118949.5172.37.camel@ht.satnam> <20090604124631.GB19459@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604124631.GB19459@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 01:46:31PM +0100, Ralf Baechle wrote:
> On Thu, Jun 04, 2009 at 06:05:49PM +0530, Jaswinder Singh Rajput wrote:
> 
> > Make ioctl.h compatible with asm-generic/ioctl.h and userspace
> > 
> > fix the following 'make headers_check' warning:
> > 
> >   usr/include/asm-mips/ioctl.h:64: extern's make no sense in userspace
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Thanks, applied.

Hi Ralf.

Any specific reason why mips does not use include/asm-generic/ioctl.h?
Had mips done so this would not have been an issue.

	Sam
