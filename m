Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbXJaQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbXJaQQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXJaQQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:16:04 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:44497 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXJaQQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:16:02 -0400
Message-ID: <4728AA49.6020405@zabbo.net>
Date: Wed, 31 Oct 2007 09:16:09 -0700
From: Zach Brown <zab@zabbo.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Ric Wheeler <ric@emc.com>
CC: Mike Waychison <mikew@google.com>, Chris Mason <chris.mason@oracle.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com> <47260AB1.9000003@zabbo.net> <472631FE.9070003@google.com> <47263BEC.30501@zabbo.net> <472861A8.8020709@emc.com>
In-Reply-To: <472861A8.8020709@emc.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The second use case is to look at the physical layout of blocks on disk
> for a specific file, use Mark Lord's write_long patches to inject a disk
> error and then read that file to make sure that we are handling disk IO
> errors correctly.  A bit obscure, but really quite useful.

Hmm, yeah, that's interesting.

> We have also used FIBMAP a few times to try and map an observed IO error
> back to a file. Really slow and painful to do, but should work on any
> file system when a better method is not supported.

We're getting off of this FIBMAP topic, but this interests me.  Can we
explore this a little?  How did you find out about the error without
having a file to associate with it?  Drive scrubbing, or some such?

- z
