Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZHaUTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZHaUTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZHaUTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:19:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZHaUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:19:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Date: Mon, 31 Aug 2009 22:19:09 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-6-generic; KDE/4.3.0; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1251563892.13287.11.camel@wall-e> <200908311744.52972.arnd@arndb.de> <20090831171956.GA3036@x200.localdomain>
In-Reply-To: <20090831171956.GA3036@x200.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908312219.09629.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19OBOs/BxWNVsoZz/+DHMUAxybdUfcdxg4PUDa
 NgQnoTqmbVS50Bmdpw5dguQH7niyap7woPyeBhwmEE6G6xHa5V
 IKe4P6j5JQNcyNeo/lCwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Alexey Dobriyan wrote:
> I don't like any churn in that area. Everything is ready for ->proc_fops usage.
> So we should simply convert users away.
> Actually most of SCSI and IDE is already done, just wasn't sent yet.

Ok, fair enough. I was expecting that the remaining drivers are suffering from
lack of testing options, as many of them are rather obscure. If you think we can
just convert them in one step, that's even better.

	Arnd <><
