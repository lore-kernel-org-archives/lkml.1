Return-Path: <linux-kernel-owner+w=401wt.eu-S1765222AbYDYS2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765222AbYDYS2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYDYS1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:27:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46912 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939AbYDYS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:27:54 -0400
Date: Fri, 25 Apr 2008 20:27:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
In-Reply-To: <1209078352-7593-3-git-send-email-hpa@zytor.com>
Message-ID: <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-04-25 01:05, H. Peter Anvin wrote:

>This creates two generic files with common integer definitions; one
>where 64 bits is "long" (most 64-bit architectures) and one where 64
>bits is "long long" (all 32-bit architectures and x86-64.)

long long is 64 bits on both 32 and 64, is not it?
If so, the split between 32 and 64 should not be necessary.

