Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZBRK0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZBRK0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZBRKZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:25:58 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46211 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZBRKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:25:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LOhbC5mGOmngLv3CDWZaJ7Sjq67dvKYS3Nb5MSaP5xyiIclYUbrM59l9pdqqEX8z8k
         J1X5NTTxb60MvQ9+ifXOYubBc3eE3L7b1R1wHj/0oKhwwPwpTSLqoNJLRzJwDwV4//dY
         uA6BHkzdSrW5OsLDBXjNeAgdKJLVPW2csplTs=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 11:25:53 +0100
Message-Id: <1234952753.10531.48.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not in the patchset, but I have code for inserting megamodules
already. So, I can benchmark and compare these setups:

- Monolithic kernel without initramfs.
- Generic with initramfs. insmod'ing all modules.
  (95 of them in this case.)
- Generic with initramfs, insmod'ing a megamodule.

Is there anything else I ought to test?

Time is a bit short today, but I hope to have the results tomorrow night
(CET) at the latest.

/Andreas


