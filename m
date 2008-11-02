Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYKBSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYKBSzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYKBSsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:48:55 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:48983 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbYKBSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:48:53 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 2 Nov 2008 10:48:51 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Olaf van der Spek <olafvdspek@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll behaviour after running out of descriptors
In-Reply-To: <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com> 
 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008, Olaf van der Spek wrote:

> On Sun, Nov 2, 2008 at 7:25 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > A bug? For starters, epoll_wait does NOT create new files, so no EMFILE
> > can come out from there.
> 
> It's accept that returns EMFILE.
> 
> > You are saturating the port space, and your whole code logic is rather (at
> > least) buggy. Try a `netstat -n -t | grep TIME_WAIT | wc -l`
> 
> What makes you think I'm saturating the port space?
> That space is way bigger than 1 k AFAIK.

Why don't you grep for TIME_WAIT?



- Davide


