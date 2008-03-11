Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYCKNlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYCKNlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYCKNlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:41:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38678 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYCKNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:41:13 -0400
Date: Tue, 11 Mar 2008 09:40:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Scott Edwards <lkml@foss.daxal.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.3 ARCH=um FTBFS c/o undefined reference to
	`i386_mmap_check'
Message-ID: <20080311134055.GA6997@c2.user-mode-linux.org>
References: <20080311043516.4D92F320001@mail.daxal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311043516.4D92F320001@mail.daxal.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 11:35:16PM -0500, Scott Edwards wrote:
> I'm attempting to build a user mode linux kernel with some grsec features 
> (no PaX, apparently incompatible)  I'm using 2.6.24.3 and 
> grsecurity-2.1.11-2.6.24.3-200803031942.patch.gz  This is built on a Debian 
> Etch host.  I have compiled linux-2.6.25-rc3-mm1 which also seems to run 
> without complaint. 

> mm/built-in.o: In function `do_mmap_pgoff':
> (.text+0xe35d): undefined reference to `i386_mmap_check'
> mm/built-in.o: In function `do_brk':
> (.text+0xf3be): undefined reference to `i386_mmap_check'
> collect2: ld returned 1 exit status

Looks like there's some arch-specific stuff in one of your patches and
it's not there for UML.

     	       	   Jeff

-- 
Work email - jdike at linux dot intel dot com
