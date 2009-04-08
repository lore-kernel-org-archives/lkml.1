Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbZDHNLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbZDHNLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765503AbZDHNJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:09:08 -0400
Received: from ns.firmix.at ([62.141.48.66]:1630 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765166AbZDHNJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:09:04 -0400
Subject: Re: the different effect of system call fork()
From: Bernd Petrovitsch <bernd@firmix.at>
To: Sino <szj087@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cab3445d0904080553k6fc67498s73cb5b7c661ff0b@mail.gmail.com>
References: <cab3445d0904080553k6fc67498s73cb5b7c661ff0b@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 08 Apr 2009 15:08:48 +0200
Message-Id: <1239196128.5031.3.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.044 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.044 required=5
X-Spam-Score: -1.044 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, 2009-04-08 at 20:53 +0800, Sino wrote:
[...]
> I don't know whether this is the right place for this email, but I

It's probably not.

> post it here since it concerns the system call of fork.
> here is my fwo source code.
> 
> //fork1.cc
[...]
>    if (pid_t pid = fork() < 0)

I don't think that this line does what you want it to do.
Hint: Using a "pid_t" for the boolean result for a comparison seems
strange at best.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


