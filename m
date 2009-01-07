Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbZAGTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbZAGTVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZAGTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:21:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZAGTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:21:32 -0500
Message-ID: <496500D2.8080201@zytor.com>
Date: Wed, 07 Jan 2009 11:21:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Detlef Riekenberg <wine.dev@web.de>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Subject: Re: [PATCH] [TRIVIAL] linux/types.h: Don't depend on __GNUC__ for
 __le64 / __be64 [synced to git]
References: <1230594921.7652.35.camel@p4.lan>	 <1231029623.7225.10.camel@p4.lan> <1231320558.5547.21.camel@p4.lan>
In-Reply-To: <1231320558.5547.21.camel@p4.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detlef Riekenberg wrote:
> Hi.
> <linux/cdrom.h> is used in Wine, but failed to compile with pcc.
> (__le64 and __be64 are referenced in <linux/byteorder/little_endian.h>)
> 
> There is no reason to restrict the typedefs to __GNUC__.
> This Patch is trivial for gcc and icc, but required for other compiler.
> 
> As reference, the typedefs for __u64 and __s64 where fixed to be
> available for other compiler on 02. Mai 2008 by H. Peter Anvin
> (commit edfa5cfa3dc5bfa95e6aa82a2b8904e7f6c35ed7)
> 
> Wine: http://www.winehq.org
> pcc:  http://pcc.ludd.ltu.se
> 
> This patch is again a resync to current git.
> Is there anything, that I can do for this Patch?
> 

For what it's worth...

Acked-by: H. Peter Anvin <hpa@zytor.com>

This isn't an x86 thing so it's a bit out of scope for me to push it 
through -tip, but it's a valid bugfix.

	-hpa

