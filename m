Return-Path: <linux-kernel-owner+w=401wt.eu-S966101AbXDBXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966101AbXDBXd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966105AbXDBXd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:33:26 -0400
Received: from ozlabs.org ([203.10.76.45]:39965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966101AbXDBXdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:33:25 -0400
Subject: Re: [PATCH 0/2] Use a single loader for i386 and x86_64
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
In-Reply-To: <20070402194344.GA7711@redhat.com>
References: <20070402194344.GA7711@redhat.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 09:32:49 +1000
Message-Id: <1175556769.12230.462.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 16:43 -0300, Glauber de Oliveira Costa wrote:
> This patch moves lguest.c one level bellow, and enhances it with the
> ability to kick off 64 binaries. It would be much easier to just ifdef
> functions, but I have x86_64 machines loading 32-bit kernels as a longer
> goal, and that's why the patch features the load_elf_header() function.

Hi Glauber!

	I've been writing documentation, and in the process completely
reorganised and cleaned up this file.  I have also been working on
getting rid of the gratuitous u32's for addresses and trying to cleanse
myself of 32-bit thinking!

	I've now pushed the changes to the repo.  They should simplify this
patch...

Thanks!
Rusty.


