Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYAEJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYAEJcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYAEJbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:31:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755321AbYAEJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:31:31 -0500
Date: Sat, 5 Jan 2008 01:30:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [2.6.25 patch] remove a.out interpreter for ELF executables
Message-Id: <20080105013053.b46cd28b.akpm@linux-foundation.org>
In-Reply-To: <200801011536.32598.ak@suse.de>
References: <20080101134749.GJ2360@does.not.exist>
	<200801011536.32598.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 15:36:32 +0100 Andi Kleen <ak@suse.de> wrote:

> On Tuesday 01 January 2008 14:47:49 Adrian Bunk wrote:
> > This patch contains the scheduled removal of the a.out interpreter 
> > support for ELF executables.
> 
> I already have a similar patch queued
> 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-aout-interpreter
> 
> Also removal of the old unused iBCS hooks while I was on it
> 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-ibcs-support
> 

Guys, please take a look at similar patches from David in -mm before even
vaguely thinking of breathing anywhere in the remote vicinity of
fs/binfmt_elf.c (sob).

