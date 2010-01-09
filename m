Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476Ab0AIHOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab0AIHOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 02:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205Ab0AIHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 02:14:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46084 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0AIHOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 02:14:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E1+yq11QTzBlOxVo4C7NOW8mgyi2SAVxTbPcZkam/LvKSJLl1VpjgTKRjR/nBi9j3T
         sqNrzmqoxjICBBjGdWRcEu4Uu4YLXJXs9W+zsBz2M1RvnNynfzrxTSeh4lS9XK7WAvRr
         /u0ez2uC1nZ+KfOf3ti5zv90cVpgjryFk4f+g=
MIME-Version: 1.0
In-Reply-To: <4B47822E.1080402@gmail.com>
References: <4B47822E.1080402@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 9 Jan 2010 02:13:45 -0500
Message-ID: <8bd0f97a1001082313h40b83a8cs22046a80c3120b38@mail.gmail.com>
Subject: Re: [PATCH] Blackfin arch: Fix decoding of opcodes 41-47 in 
	decode_instruction()
To: Roel Kluin <roel.kluin@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 14:06, Roel Kluin wrote:
> This condition allowed only decoding of opcode 0x0040
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/blackfin/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> Found with static code analysis. Correct?

looks like it to me:
   0:   40 00           STI R0;
   2:   41 00           STI R1;
   4:   42 00           STI R2;
   6:   43 00           STI R3;
   8:   44 00           STI R4;
   a:   45 00           STI R5;
   c:   46 00           STI R6;
   e:   47 00           STI R7;

ive added this to the Blackfin repo, thanks
-mike
