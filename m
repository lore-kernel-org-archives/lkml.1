Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZEPGkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZEPGkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 02:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZEPGkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 02:40:10 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50979 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZEPGkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 02:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gD2o4kjU5/28r+DXJPoOROXCm80oHhZDxrb2QN4XOcvyqEjz4zz8P8ILAN2291wEAV
         mOtz4XZuFiJwT61Zn7HwzodGc7qoluUC1h0N4yWzArbagvrhPvZRqSGx4lqz7U2pXLq5
         E1ys10FTLFc/1I1HbpTMngsUJJIVtqQVmZJCE=
MIME-Version: 1.0
In-Reply-To: <20090515195520.GA7715@damson.getinternet.no>
References: <20090515195520.GA7715@damson.getinternet.no>
Date: Sat, 16 May 2009 09:40:08 +0300
X-Google-Sender-Auth: 1c489985eace7b0f
Message-ID: <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: make bitfield annotations be valid C
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:55 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From bb8926742d87da95aeb373bc2d4b35a554c5001b Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 15 May 2009 21:34:36 +0200
> Subject: [PATCH] kmemcheck: make bitfield annotations be valid C
>
> According to Al Viro, the syntax we were using (putting #ifdef inside
> macro arguments) was not valid C. He also suggested using begin/end
> markers instead, which is what we do now.
>
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Al, are you okay with this?
