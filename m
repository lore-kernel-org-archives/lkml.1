Return-Path: <linux-kernel-owner+w=401wt.eu-S938350AbXGTXhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938350AbXGTXhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXGTXhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:37:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:30057 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXGTXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tQNDY8VnK4DxQnK4Sc2twXGqzqSaioDghJfltyZimX81Wdw/hohgmq/WT9fSYKG+9AY3lKP5ProfVUpfmJ3845eQnGQXf8/rPEK3MG+3WBTzYqrS9dXgj9UzVpRAWAXpN3a0W7laWe6D8nAiHY5vWeyCS65F3PuGzE60hN3jndw=
Subject: Re: [PATCH 2/7] console: fix section mismatch warning in vgacon.c
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070720212743.GB25064@uranus.ravnborg.org>
References: <20070720212743.GB25064@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 07:37:29 +0800
Message-Id: <1184974649.4538.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 23:27 +0200, Sam Ravnborg wrote:
> Fix following section mismatch warning:
> WARNING: vmlinux.o(.text+0x121e62): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
> 
> Browsing the code it seems that vgacon_scrollback_startup() is only
> called during the init phase so the reference to the .init.text
> section is OK.
> Teach modpost not to warn using ___init_refok.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony

