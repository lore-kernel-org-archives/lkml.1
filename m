Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYL3AFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYL3AFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYL3AFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:05:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYL3AE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:04:59 -0500
Message-ID: <495965A7.3010700@zytor.com>
Date: Mon, 29 Dec 2008 16:04:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Detlef Riekenberg <wine.dev@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/types.h: Do not depend on __GNUC__ for __le64 and
 __be64
References: <1230594921.7652.35.camel@p4.lan>
In-Reply-To: <1230594921.7652.35.camel@p4.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detlef Riekenberg wrote:
> Hi.
> <linux/cdrom.h> is used in Wine, but failed to compile with pcc.
> (__le64 and __be64 are referenced in <linux/byteorder/little_endian.h>)
> 
> There is no reason to restrict the typedefs with __GNUC__.
> As reference, the typedefs for __u64 and __s64 where fixed
> to be available with pcc on 02. Mai 2008 by H. Peter Anvin
> (commit edfa5cfa3dc5bfa95e6aa82a2b8904e7f6c35ed7)
> 
> Wine: http://www.winehq.org
> pcc:  http://pcc.ludd.ltu.se
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

