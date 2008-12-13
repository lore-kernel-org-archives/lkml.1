Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbYLMQ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbYLMQ4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLMQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:56:15 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:64590 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYLMQ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=lYUNVMBSZaLCuVUo6IFL+X4L+k0fKbFYcWAqSW8tlqfFiXuUq3yudhxucflSKJQg4K
         9nKjlIhdvwWSjs++8GBt088bQQOsXVmJ9pFbocvFhieB2Xt5biafKqlkAIwHhPKzJVzv
         pXLVoCQdKHQJUa5LEaB6V869hNo1iC10RBPoI=
Date: Sat, 13 Dec 2008 19:48:45 +0300
From: Gregory Petrosyan <gregory.petrosyan@gmail.com>
To: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Misuse of sizeof
Message-ID: <20081213164845.GA19407@home>
Mail-Followup-To: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>,
	linux-kernel@vger.kernel.org
References: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 05:31:06PM +0100, Giangiacomo Mariotti wrote:
> IMO there's a bug in the use of sizeof in /arch/x86/boot/main.c, it's
> also a strange style.

> -	BUILD_BUG_ON(sizeof boot_params != 4096);
> -	memcpy(&boot_params.hdr, &hdr, sizeof hdr);
> +	BUILD_BUG_ON(sizeof(boot_params) != 4096);
> +	memcpy(&boot_params.hdr, &hdr, sizeof(hdr));

The 'sizeof xxx' style is perfectly valid.

	Gregory
