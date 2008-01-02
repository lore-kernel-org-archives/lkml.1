Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYABNBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYABNBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYABNBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:01:03 -0500
Received: from smtp01.cdmon.com ([212.36.75.232]:50079 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbYABNBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:01:02 -0500
X-Greylist: delayed 1144 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2008 08:01:02 EST
Date: Wed, 2 Jan 2008 13:42:37 +0100
From: DervishD <lkml@dervishd.net>
To: Abdel <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: macro _set_base - "do - while(0)" question
Message-ID: <20080102124237.GA12683@DervishD>
Mail-Followup-To: Abdel <draconux@gmail.com>,
	linux-kernel@vger.kernel.org
References: <60d29d630801020345i200a2f72pe860b0d38b530a05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60d29d630801020345i200a2f72pe860b0d38b530a05@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abdel :)

* Abdel <draconux@gmail.com> dixit:
> In file include/asm-i386/system.h,  _set_base and _set_limit use an
> useless do ... while(0)
> 
> Why is this needed ?

Google for "do while swallow semicolon". This looks like an useless and
weird construction but it is very useful when it comes to macros (you
can define variables inside the block and you can use your macro as any
other statement, it won't swallow the semicolon).

Raúl Núñez de Arenas Coronado
-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
