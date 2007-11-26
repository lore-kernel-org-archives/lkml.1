Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXKZSDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXKZSDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbXKZSDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:03:07 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2020 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXKZSDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:03:05 -0500
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from
	<linux/kernel.h> instead
From: Joe Perches <joe@perches.com>
To: Denis Cheng <crquan@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, dengxw@163.com,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <1196098095-8995-1-git-send-email-crquan@gmail.com>
References: <20071126143939.GB28022@gondor.apana.org.au>
	 <1196098095-8995-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 10:01:44 -0800
Message-Id: <1196100104.31590.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 01:28 +0800, Denis Cheng wrote:
> -static void hexdump(unsigned char *buf, unsigned int len)
> -{
> -	while (len--)
> -		printk("%02x", *buf++);
> -
> -	printk("\n");
> -}

#define hexdump(buf, len) \
	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, \
	               (buf), (len), false)

requires no other changes.


