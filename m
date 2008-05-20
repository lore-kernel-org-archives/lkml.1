Return-Path: <linux-kernel-owner+w=401wt.eu-S1765983AbYETNpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765983AbYETNpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbYETNp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:45:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:39940 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYETNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:45:27 -0400
Date: Tue, 20 May 2008 09:45:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: John R Moser <nigelenki@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UML and VMI ... how does UML work?
Message-ID: <20080520134517.GA6990@c2.user-mode-linux.org>
References: <loom.20080519T235035-223@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20080519T235035-223@post.gmane.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 11:58:40PM +0000, John R Moser wrote:
> I've been googling around but can't find a good resource for
> technically how UML works.  I'm thinking about specifically the task
> of implementing a virtualization platform without kernel
> hooks... this lead me to dancing around checking out existing
> technology and noticing claims that UML can run on an unmodified
> kernel without special needs.

There's nothing magic.  It turns out that the system call interface is
sufficient to virtualize an entire system, and UML is an existence
proof of that.  The major mappings are:
      system calls -> ptrace
      memory -> mmap, munmap, mprotect
      interrupts -> signals
      timer -> interval timer

> In short, I'm curious about how UML works because I'm interested in knowing if
> it's theoretically possible to remove the UML code (i.e. compile it out) and
> then boot a kernel within an application that gives it a VMI structure to ...
> act exactly as UML.

This paragraph is very unclear to me...

     	       	       Jeff

-- 
Work email - jdike at linux dot intel dot com
