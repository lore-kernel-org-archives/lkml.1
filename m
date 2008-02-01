Return-Path: <linux-kernel-owner+w=401wt.eu-S965035AbYBABhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035AbYBABhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYBABhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:37:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55696 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYBABhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:37:09 -0500
Date: Fri, 1 Feb 2008 02:37:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Justin Banks <justin.banks@bakbone.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to tell i386 from x86-64 kernel
In-Reply-To: <960D0E79B4E503448AD14B5E40A5C1C7BB54CE@USX1.corp.bb>
Message-ID: <Pine.LNX.4.64.0802010229250.4864@fbirervta.pbzchgretzou.qr>
References: <960D0E79B4E503448AD14B5E40A5C1C7BB54CE@USX1.corp.bb>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't strip Ccs, thanks. (and try not to tofu either.)

On Jan 31 2008 17:01, Justin Banks wrote:
>
>uname -a will tell you, though.

No. uname is generally not a reliable source to tell you the bitness (or 
more precisely, the arch). It may even happen that you cannot find out 
at all if access permissions are set 'correctly'.
You may find ELF64 files flying around in the filesystem, and while that 
is a strong indication of a 64-bit kernel being running, it is not a 
definite Yes.


02:31 ccgmbh:~ > uname -a
Linux ccgmbh 2.6.23.10-ccj62-regular #1 SMP 2007/10/26 14:17:15 UTC i686 
athlon i386 GNU/Linux

02:32 ccgmbh:~ > file `which uname`
/bin/uname: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for 
GNU/Linux 2.6.4, dynamically linked (uses shared libs), stripped
