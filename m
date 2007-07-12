Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXGLMwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXGLMwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761426AbXGLMwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:52:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:40957 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456AbXGLMwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=rn2yUIKfQzDH87W7KsYzxpUWTQbTtD+ib2QR/gC14mGtBwNy+qavxDoi24/b4PqIV7xYcuNYiw1bXl43WKR7O4WPylXvnhIWBkxUDqZfRRn+Vdh9sPYhiBARQPiglPU9tP7QYtoJKXhNFrD7ad+YFr3JgpqF/AQ2it72E9MZ6zo=
Message-ID: <46962413.8060702@gmail.com>
Date: Thu, 12 Jul 2007 18:22:35 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Ni@m" <niam.niam@gmail.com>
CC: davids@webmaster.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NPTL
References: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>	 <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com> <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
In-Reply-To: <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ni@m wrote:
> So I can say that in linux 'thread' == 'process'?
> 

No. It's more like, in linux threads are visible to the kernel (unlike
in N:1 thread models, linux is 1:1). Threads are the basic unit of
scheduling.

A process can have >1 threads.

> Is kernel routine 'kthread' creating a process?
> I'm just thinking on this subject: if to create 'real threads' - will
> it increase performance? Should I ever think in this way?
> When I say 'real thread' - I mean the thread that doen't switch
> context when it's starting to run.
> 

What do you mean by context?

Each thread has it's own stack, registers, etc. which form it's context.
A process has more info like file descriptors, IPC resources, virtual
memory info. Between scheduling threads of the same process these stay same.

-jb
-- 
Tact is the art of making a point without making an enemy.
