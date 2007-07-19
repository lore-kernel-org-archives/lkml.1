Return-Path: <linux-kernel-owner+w=401wt.eu-S939853AbXGSPz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939853AbXGSPz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939786AbXGSPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:55:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:40833 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939775AbXGSPzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:55:35 -0400
In-Reply-To: <469DE555.10507@anagramm.de>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <469DE555.10507@anagramm.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6E2D9630-377F-4A92-8D18-0696E86E1664@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 03/33] powerpc: Refuse to build 64-bit with GCC-4.2.0 and CONFIG_MODULES
Date: Thu, 19 Jul 2007 17:55:25 +0200
To: Clemens Koller <clemens.koller@anagramm.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Segher Boessenkool <segher@kernel.crashing.org>
>> ...since this won't work (compiler bug, see <http://gcc.gnu.org/ 
>> PR31490>).
>
> The bug report says IA64 is broken, too. Please verify and extend the
> patch if possible...

The GCC bug exists on all architectures.  Linux build is only
affected on PowerPC, and only when modules are enabled, as far
as I know.  I have no way to build IA64 kernels right now, someone
else will have to check and create a similar patch if necessary.

> gcc-4.2.1 will be released soon.

For some value of "soon".  Likely this bug will be fixed in 4.2.1,
and if not, I'll just update the range check in here.


Segher

