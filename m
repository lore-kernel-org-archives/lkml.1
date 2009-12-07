Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbZLGPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbZLGPNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935264AbZLGPNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:13:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935260AbZLGPNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:13:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: XD/smartmedia - how to implement it right?
Date: Mon, 7 Dec 2009 16:13:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Alex Dubov <oakad@yahoo.com>,
       "J?rn Engel" <joern@logfs.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <109361.10237.qm@web37604.mail.mud.yahoo.com> <20091205190913.GA1309@ucw.cz> <1260134820.23100.23.camel@maxim-laptop>
In-Reply-To: <1260134820.23100.23.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071613.43421.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/z/npaX3WoUCveJ0zNe4DGvH5vIClx8TwTEjI
 6bp1utCL1vSUa7VkLmFNSEJLFzENGEpD1pkKDcBqTkVZ+WPUGj
 jAY8k/jYytWoL9qSFdy/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 December 2009, Maxim Levitsky wrote:
> Supporting wear leveling in hardware is easier, because this way, they
> can be sure it works well, and not depend on each and every driver
> implementation to do that right.

Assuming that hardware engineers know what they are doing, yes.
Unfortunately the hardware people seem to be just as clueless about
this as the every device driver writer, which actually makes this much
worse. Having bad wear leveling in hardware often means that the
card eats your data, no matter what the driver does. Doing it in software
means that it's broken most of the time but fixable.

	Arnd <><
