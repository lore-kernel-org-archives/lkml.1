Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZADVzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZADVzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZADVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:55:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:57744 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751475AbZADVzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:55:25 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/V299IfOfV+6mQqyYiVqE135xxTRBZ+o2qGjNYl8
	fM1pPNNLjnamZ5
Date: Sun, 4 Jan 2009 22:55:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Trilok Soni <soni.trilok@gmail.com>
cc: linux-kernel@vger.kernel.org,
       ext Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: videobuf-dma-sg.c: build failure on latest Jan 3,2009 tip
In-Reply-To: <5d5443650901040234y799c4b0en482954db0f4c65c0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901042254300.4288@axis700.grange>
References: <5d5443650901040234y799c4b0en482954db0f4c65c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Trilok Soni wrote:

> Mauro,
> 
> Build failure on latest tip of linux-2.6 mainline kernel while doing
> it for n800 tablet.
> 
>   CC      drivers/media/video/videobuf-core.o
>   CC      drivers/media/video/videobuf-dma-sg.o
> drivers/media/video/videobuf-dma-sg.c: In function 'videobuf_vm_fault':
> drivers/media/video/videobuf-dma-sg.c:391: error: implicit declaration
> of function 'clear_user_page'
> make[3]: *** [drivers/media/video/videobuf-dma-sg.o] Error 1
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
> 
> 
> tip commit id:
> commit 7d3b56ba37a95f1f370f50258ed3954c304c524b

This

http://marc.info/?l=linux-video&m=123101763514517&w=2

should be the fix for the problem.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
