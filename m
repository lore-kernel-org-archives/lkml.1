Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYJEAAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYJEAAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYJEAAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:00:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYJEAAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:00:32 -0400
Date: Sat, 4 Oct 2008 20:00:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] Return an error when setting a nonexistent tracer
In-Reply-To: <48E7CC5C.7080306@gmail.com>
Message-ID: <alpine.DEB.1.10.0810041959160.11586@gandalf.stny.rr.com>
References: <48E7CC5C.7080306@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Oct 2008, Frederic Weisbecker wrote:

> When one try to set a nonexistent tracer, no error is returned
> as if the name of the tracer was correct.
> We should return -EINVAL.

Thanks! This has been something I've been meaning to do for a long
time but have never got around to doing it.

( I knew if I waited long enough, someone else would do it ;-)

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

