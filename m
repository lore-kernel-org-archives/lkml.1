Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYFAIwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYFAIwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYFAIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:52:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYFAIwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:52:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Sun, 1 Jun 2008 10:52:03 +0200
User-Agent: KMail/1.9.9
Cc: David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <200805312240.50720.arnd@arndb.de> <48421D65.8040301@lougher.demon.co.uk>
In-Reply-To: <48421D65.8040301@lougher.demon.co.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806011052.05921.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Dj+2Mnoori0VIdY65P3XaTRxb91brnGl7Hz5
 AioNW7GwYMd90pCOVEL2+QuMeCv+xrtPERwsMpLIDLQVHIffO3
 GaQnjF/muycPm/JOmmJbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008, Phillip Lougher wrote:
> If I read the patches correctly, when a file page is written to, only 
> that page gets copied into the page cache and locked, the other pages 
> continue to be read off disk from cramfs?  With Unionfs a page write 
> causes the entire file to be copied up to the r/w tmpfs and locked into 
> the page cache causing unnecessary RAM overhead.

Yes, that's right.

	Arnd <><
