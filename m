Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYEXA4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYEXA4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYEXA4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:56:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYEXA4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:56:37 -0400
Date: Fri, 23 May 2008 20:56:30 -0400
From: Rik van Riel <riel@redhat.com>
To: "Fausto Richetti Blanco" <fausto.blanco@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pipe buffers' limit of 16 * 4K
Message-ID: <20080523205630.444fe2b9@bree.surriel.com>
In-Reply-To: <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
	<d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 21:19:13 -0300
"Fausto Richetti Blanco" <fausto.blanco@gmail.com> wrote:

> Hello guys,
> 
>        I'm working with a 2.6.9 kernel (ok, I know it's quite old) and
> faced a problem with the 4K (one page) buffer limit for the pipes.
> I've found that in the 2.6.11 the pipes' buffers were changed to a
> circular list of pages which increased this limit to 16 * 4K. This
> limit is hardcoded here /usr/src/linux/include/linux/pipe_fs_i.h:6
> #define PIPE_BUFFERS (16)
> 
>        Is there a reason for this not to be an adjustable parameter
> (eg.: by an ulimit in the userspace) ?
 
What is the problem you found?

Why do you need to change the limit from 16?

Did it bring you any performance enhancements?

If so, how much?

-- 
All rights reversed.
