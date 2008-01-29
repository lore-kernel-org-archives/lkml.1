Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbYA2NYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbYA2NYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbYA2NXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:23:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:18424 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbYA2NXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FugZtz7zy84Nlvcokj14m59RjXpoxQjLav77lTOlKZNyfXQOP+ygjEXvDDYrbIkCFugj3n0gLZK3FHU5jAOXrS0g4dvt+KRhCiuIwWutLWCjpPj5ULz2VQstD4TOCwViat2vfnjCSCwuYtUnNGh3IrPVF6xH/ajjpKjn5ej/PTw=
Message-ID: <479F28DB.3040201@gmail.com>
Date: Tue, 29 Jan 2008 14:23:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Yoav Artzi <yoavar@checkpoint.com>, linux-kernel@vger.kernel.org
Subject: Re: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
References: <479F1866.4050007@checkpoint.com> <479F247D.8040401@msgid.tls.msk.ru>
In-Reply-To: <479F247D.8040401@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2008 02:05 PM, Michael Tokarev wrote:
> (And try to avoid such types there, use u32 or u64 and the like
> that explicitly specify size).

... and don't pass pointers to _IOC macros as well.
