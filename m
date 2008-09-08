Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYIHIfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYIHIfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 04:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYIHIfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 04:35:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYIHIfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 04:35:20 -0400
Message-ID: <48C4E3B4.80506@zytor.com>
Date: Mon, 08 Sep 2008 01:35:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Alain Knaff <alain@knaff.lu>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu> <c384c5ea0809061529g2c7280d8j216f7791ceeb439a@mail.gmail.com> <48C30B4D.7030700@knaff.lu> <200809070117.56503.rob@landley.net>
In-Reply-To: <200809070117.56503.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> Actually, from what I've seen the main reason lzma doesn't get used for 
> tarballs a lot is that whoever originally created it didn't include a 
> fingerprint.  You can go "file tar.gz" or "file tar.bz2" and it can figure 
> out by looking at the contents of the file what it _is_, but last I checked 
> there's no obvious way to tell an lzma file from the output of /dev/urandom.  
> This causes all sorts of small but annoying problems, and discourages its use 
> a bit...
> 

Both 7zip and LZMA-Utils have serious file format problems.  The author 
of LZMA-Utils is working on a new format, which is likely to be widely 
adopted once it materializes.

	-hpa
