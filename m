Return-Path: <linux-kernel-owner+w=401wt.eu-S967101AbZLIBcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967101AbZLIBcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967091AbZLIBcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:32:20 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:55079 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967092AbZLIBcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:32:20 -0500
Date: Wed, 9 Dec 2009 01:31:10 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: re.emese@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
Message-ID: <20091209013109.GA18448@linux-mips.org>
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 08:14:46AM +0300, Alexey Dobriyan wrote:

> Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
> Content-Type: text/plain; charset=ISO-8859-1
> 
> > -   	struct inode *(*alloc_inode)(struct super_block *sb);
> > +   	struct inode *(* const alloc_inode)(struct super_block *sb);
> 
> Good rule is if adding const doesn't move object from one section
> to another, it isn't worth it.

On MIPS I've changed a few pointer arguments that frequently were abused
by platform-specific code to const just to make sure such code blows up
at compile time and not later in my mail folder at review time.

  Ralf
