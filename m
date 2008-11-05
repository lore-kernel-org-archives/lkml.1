Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYKEJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYKEJfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYKEJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:35:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:20846 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYKEJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:35:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PGaEaxsBtrU0fq7IZwq2UBMmm2bMALsFJWzbmEgwjIWa7jaYGSLfrfsDr0Mm8sDaHQ
         0x93lHhWMg3p6/oLOdeVrPQY6J3qJGYftfHtRy+1VhCJaXFJ2qcNAccQ0yrkZ/kKOEvG
         DW1136SQwIO/rQ6HuZqeOPpFjuXT7TtJA5hjE=
Message-ID: <491168DC.6070508@gmail.com>
Date: Wed, 05 Nov 2008 10:35:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Lior Dotan <liodot@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: Re: [STAGING] slicoss - use kzalloc
References: <491077E3.4010702@gmail.com> <4910C63F.7040309@gmail.com> <491166F5.7030102@gmail.com>
In-Reply-To: <491166F5.7030102@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2008 10:27 AM, Lior Dotan wrote:
> This patch uses kzalloc() where really applicable.

ack this, but there is another problem.

sizeof(struct physcard *) is wrong size for that allocation, care to send a fix
for this (and revice the rest of allocations)? I wonder how this could work with
SLAB_DEBUG on, maybe nobody tried...
