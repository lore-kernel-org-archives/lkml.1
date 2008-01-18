Return-Path: <linux-kernel-owner+w=401wt.eu-S1764939AbYARScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764939AbYARScr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764166AbYARSaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:30:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35292 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764089AbYARSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:30:01 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <20080118180749.GA7688@c2.user-mode-linux.org> (message from Jeff
	Dike on Fri, 18 Jan 2008 13:07:49 -0500)
Subject: Re: UML is leaking memory in arch_dup_mmap
References: <E1JFsQo-0000aG-BZ@pomaz-ex.szeredi.hu> <20080118180749.GA7688@c2.user-mode-linux.org>
Message-Id: <E1JFvyQ-00014P-Vl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 19:29:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 18, 2008 at 03:42:54PM +0100, Miklos Szeredi wrote:
> > uml:~#  grep arch_dup_mmap /proc/slab_allocators
> > size-32: 10861 arch_dup_mmap+0x9f/0x130
> 
> Whoops - try the patch below.

Yup, that seems to have solved it.  Thanks.

Miklos
