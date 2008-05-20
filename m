Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYETT0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYETT0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbYETTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:24:48 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42193 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763255AbYETTYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:24:41 -0400
Date: Tue, 20 May 2008 15:24:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080520192436.GA12102@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com> <20080520161047.GA9598@c2.user-mode-linux.org> <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com> <20080520175624.GA10889@c2.user-mode-linux.org> <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:01:02PM +0100, Tom Spink wrote:
> I'm a hardy.  I bet it's 893f802872c3.
> 
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy.git;a=commitdiff;h=893f802872c3e3c6e4bb40c3be4845784b81b934

Looks right, and mmap_min_addr is in mainline, just with a value of
zero.  So, it looks like the right thing to do is read the value of
/proc/sys/vm/mmap_min_addr and start bottom there.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
