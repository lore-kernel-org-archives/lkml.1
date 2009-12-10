Return-Path: <linux-kernel-owner+w=401wt.eu-S1761711AbZLJVT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761711AbZLJVT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbZLJVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:19:56 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:57263 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429AbZLJVTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:19:55 -0500
Message-ID: <4B21656B.1090607@lougher.demon.co.uk>
Date: Thu, 10 Dec 2009 21:17:31 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: dedekind1@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       Tim Bird <tim.bird@am.sony.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into
 a 	separate file
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>	 <20091207145705.cd30cae8.akpm@linux-foundation.org>	 <4B1ED122.3040309@lougher.demon.co.uk>	 <1260352852.19669.1253.camel@localhost>	 <4B2042FA.8080406@lougher.demon.co.uk> <10f740e80912100201l6d83588evff46e95ec96d0aed@mail.gmail.com>
In-Reply-To: <10f740e80912100201l6d83588evff46e95ec96d0aed@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 
>> Yes I did consider using the cryptoapi, but this doesn't have support for
>> lzma in mainline.
> 
> IIRC, Felix Fietkau added support for that for OpenWRT...
> 

Yes, but it isn't in mainline, and OpenWRT don't appear to have tried to submit
it.  IMHO the major problem with their patch is it uses a second private copy
of lzma, rather than being a wrapper around the pre-existing lzma implementation.
I don't think it's going to be easy to get a second lzma implementation accepted
into mainline, when it took so long to get one accepted.  I have nothing against
the cryptoapi, but it doesn't seem likely to be getting lzma support anytime soon.

As I previously said my aim is to use the pre-existing lzma implementation.  Unless
it is stupendously bad (which it isn't), that seems to be the quickest, easiest and
best way to get lzma support into Squashfs.

Phillip

