Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbZFMUmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbZFMUmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbZFMUme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:42:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45357 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbZFMUmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:42:31 -0400
Message-ID: <4A340E28.4060409@cs.helsinki.fi>
Date: Sat, 13 Jun 2009 23:38:00 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de
Subject: Re: mmotm 2009-06-12-12-20 uploaded
References: <200906121940.n5CJekrh001446@imap1.linux-foundation.org> <4A32BED7.1070100@gmail.com>
In-Reply-To: <4A32BED7.1070100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 06/12/2009 09:20 PM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2009-06-12-12-20 has been uploaded to
> 
> Hi, it doesn't build with SLQB:
> init/built-in.o: In function `start_kernel':
> (.init.text+0x73e): undefined reference to `kmem_cache_init_late'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 
> SLQB doesn't define that function (opposing to other slab allocators).

This should be fixed now in for-next:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=df548b0bbaf2d4d16ce52d2f5ccdc1cfded70e06

			Pekka
