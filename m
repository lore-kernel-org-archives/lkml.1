Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYGANWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYGANWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYGANVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:21:54 -0400
Received: from mail.macqel.be ([194.78.208.39]:4936 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbYGANVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:21:53 -0400
Date: Tue, 1 Jul 2008 15:21:49 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, libdc1394-devel@lists.sourceforge.net
Subject: mmap'ed memory in core files ?
Message-ID: <20080701132149.GA32510@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I develop video acquisition software using the video1394 interface.
The images grabbed by the camera and iee1394 bus are kept in kernel
memory and made available to the user program through a mmap call done
in the libdc1394 library :

dma_ring_buffer= mmap(0, vmmap.nb_buffers * vmmap.buf_size,
		PROT_READ|PROT_WRITE,MAP_SHARED, craw->capture.dma_fd, 0);

Sometimes, my program crashes and produces a core file :)  It seems to
me that the core file does not contain the mmap'ed memory and hence
I cannot replay my program with the same image for debugging purpose.

Is it possible to configure the kernel through /proc, or through the mmap
system call to have that mmapped segment in the core file, or do I need
to modify the kernel itself to obtain the behaviour I want ?  If I
need to modify the kernel, can some kind soul provide me some pointers ?

Best regards

Philippe
