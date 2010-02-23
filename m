Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0BWRLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:11:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0BWRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:11:49 -0500
X-Authority-Analysis: v=1.0 c=1 a=CmjlpfxUhgQA:10 a=F9P6SYpZSoR84uLbQ4sA:9 a=Qt69CefceZI09HjFyrK-HvcHTFwA:4
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.212.105
Message-Id: <201002231711.o1NHBl0q010699@dell2.home>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>
cc: martyleisner@yahoo.com, martin.leisner@xerox.com
Subject: Prepending include paths when building out of tree modules
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10696.1266945107.1@dell2.home>
Date: Tue, 23 Feb 2010 17:11:47 +0000
From: "Marty Leisner" <leisner@rochester.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm building thirdparty cryptography modules (which define they're own
crypto/* files, which was more fully populated in the 2.6.24-26 range and 
conflicts with headers in my thirdparty modules. 

Since I want to use my crypto/* hierarchy instead of the kernels, and
the source has

 #include "crytpo/aes.h"

I want to prepend paths to the kernel header search.

I added the -I to NOSTDINC_FLAGS and it works but:
     a) it doesn't seem right
     b) is there a better/more clear way?

Something like PREPEND_INCLUDE_PATH or something?  (I didn't see anything in gcc to get around this)

marty
~

