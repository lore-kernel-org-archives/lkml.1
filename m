Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbYIHNPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbYIHNPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYIHNO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:14:56 -0400
Received: from lazybastard.de ([212.112.238.170]:35882 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYIHNOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:14:55 -0400
Date: Mon, 8 Sep 2008 15:14:40 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Rob Landley <rob@landley.net>
Cc: Alain Knaff <alain@knaff.lu>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Message-ID: <20080908131440.GA14563@logfs.org>
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu> <c384c5ea0809061529g2c7280d8j216f7791ceeb439a@mail.gmail.com> <48C30B4D.7030700@knaff.lu> <200809070117.56503.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200809070117.56503.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 September 2008 01:17:55 -0500, Rob Landley wrote:
> 
> I vaguely recall that lzma requires more memory to decompress than bzip2 does, 
> although I don't remember the details.  I know that bzip2 takes around 4 megs 
> (although you need space for the decompressed kernel on _top_ of that, so you 
> should be able to do it in about 8 megs total).  gunzip uses a 64k sliding 
> window plus dictionary and the whole mess should fit in about 1/4 of a meg.

Less, actually.  Iirc gzip takes about 280k for compression and
somewhere below 100k for decompression with the kernel runtime zlib.
The various copies that unpack kernels at boottime may be worse - they
are certainly rather old copies of zlib and haven't seen much
maintenance since.

Jörn

-- 
Don't worry about people stealing your ideas. If your ideas are any good,
you'll have to ram them down people's throats.
-- Howard Aiken quoted by Ken Iverson quoted by Jim Horning quoted by
   Raph Levien, 1979
