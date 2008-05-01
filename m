Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbYEARv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbYEARv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYEARvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:51:52 -0400
Received: from www17.your-server.de ([213.133.104.17]:55633 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYEARvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:51:52 -0400
Message-ID: <1209664309.481a03359f412@213.133.104.17>
Date: Thu, 01 May 2008 19:51:49 +0200
From: thomas@m3y3r.de
To: htmldeveloper@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: make[1]: *** [drivers/built-in.o] Error 1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.55.18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a.   What is the cause of the error?

The Makefile in drivers/ and drivers/media/ doesn't play well together.

> b.   Is there a relationship between the ld-warning and the subsequent errors
as shown above?

No.

To overcome this error try disabling CONFIG_DVB_CORE.

mfg
thomas

