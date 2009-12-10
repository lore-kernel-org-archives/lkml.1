Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZLJAkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZLJAkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbZLJAkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:40:47 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:60519 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759145AbZLJAkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:40:45 -0500
Message-ID: <4B2042FA.8080406@lougher.demon.co.uk>
Date: Thu, 10 Dec 2009 00:38:18 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into
 a separate file
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>	 <20091207145705.cd30cae8.akpm@linux-foundation.org>	 <4B1ED122.3040309@lougher.demon.co.uk> <1260352852.19669.1253.camel@localhost>
In-Reply-To: <1260352852.19669.1253.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> 
> Did you consider using cryptoapi? UBIFS uses zlib/lzo in cryptoapi - it
> is a very clean way.
> 

Yes I did consider using the cryptoapi, but this doesn't have support for
lzma in mainline.

My aim is add lzma filesystem support to Squashfs using the existing kernel
lzma iplementation, and to make as few changes to that as necessary.

Phillip
