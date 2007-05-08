Return-Path: <linux-kernel-owner+w=401wt.eu-S966391AbXEHLKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966391AbXEHLKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934238AbXEHLKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:10:52 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23445 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934101AbXEHLKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:10:52 -0400
Message-ID: <46405AB6.6040901@msgid.tls.msk.ru>
Date: Tue, 08 May 2007 15:10:46 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Shani Moideen <shani.moideen@wipro.com>
CC: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page()
 in kernel/kexec.c
References: <1178621444.3598.15.camel@shani-win>
In-Reply-To: <1178621444.3598.15.camel@shani-win>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shani Moideen wrote:
>                 ptr = kmap(page);
> -               memset(ptr, 0, PAGE_SIZE);
> +               clear_page(ptr);

I wonder if it's worth to invent kzmap() or something like that... ;)

/mjt
