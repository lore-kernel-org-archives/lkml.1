Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYDXHbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYDXHbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYDXHbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:31:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56158 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYDXHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:31:32 -0400
Date: Thu, 24 Apr 2008 09:31:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: "devzero@web.de" <devzero@web.de>, linux-kernel@vger.kernel.org,
       agruen@suse.de
Subject: Re: make cloneconfig ?
In-Reply-To: <9a8748490804231543h1203ff59i466e1ea9c02af0f2@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0804240930180.15791@fbirervta.pbzchgretzou.qr>
References: <251459002@web.de> <9a8748490804231543h1203ff59i466e1ea9c02af0f2@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-04-24 00:43, Jesper Juhl wrote:
>> any reason why "make cloneconfig" never made it into mainline?
>>
>>  many people are quite used to it and every time i build vanilla kernel i step into that trap  "oh - that`s a suse`ism"
>>
>>  make cloneconfig exists since /proc/config.gz - but while that one went into mainline, cloneconfig never did.
>>
>>  anyone know the reason for that ?
>>
>>  i wished, distros kernels were more similar to vanilla kernels - so what about making them more similar ?
>>
>>
>
>Isn't "cloneconfig" basically just "zcat /proc/config.gz > .config &&
>make oldconfig" ???   If so, why do we need yet another "make
><some_target>" Makefile rule? What would actually be gained?

Not just that, it also searches /boot/config-... (a redhatism)
and /lib/modules/.../.config.
So it's not like it would be a suse-only shortcut.
