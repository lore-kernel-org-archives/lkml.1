Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbXGLCKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbXGLCKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbXGLCKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:10:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760337AbXGLCKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:10:43 -0400
Message-ID: <46958D9D.9090802@zytor.com>
Date: Wed, 11 Jul 2007 19:10:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Use BIOS Keyboard variable to set Numlock
References: <Pine.LNX.4.58.0707112305390.2432@be1.lrz> <46957CBF.1000101@zytor.com> <Pine.LNX.4.58.0707120321200.28727@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707120321200.28727@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
>> That being said, one could argue that since this is a BIOS interface it
>> should be queried via INT 16h, AH=02h and stuffed in the zeropage
>> structure.  This would also solve the issue of it not being supported by
>> non-BIOS firmware.
> 
> This is an interesting option, but it's more invasive. I'd rather like a 
> feedback saying we can depend on that data area to be there.

I don't think we can.  You might find garbage there.

	-hpa
