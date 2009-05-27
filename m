Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbZE0MXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbZE0MXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbZE0MXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:23:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbZE0MXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:23:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 00/19] periodic write-back timer optimization
Date: Wed, 27 May 2009 13:23:29 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200905271323.29818.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+xLX0GS8Iw6TsjokQ6tD0QzkxKsEI3g86as7d
 TxiCtF3m4GOcV+w5XW4g52vRSOzChbsPFk1QrINQzv/l7seYR3
 YUPVGUTUmK2uL3OsC0SmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Artem Bityutskiy wrote:
> Hi,
> 
> This is the second attempt. The first one was here:
> http://marc.info/?l=linux-fsdevel&m=124301072305588&w=2
> It was very hacky and got no comments.

How does this relate to the per-BDI writeback patches that
Jens is working on? Doesn't that require a completely different
(probably simpler) implementation of your patch?

	Arnd <><
