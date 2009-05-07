Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZEGUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZEGUtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEGUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:49:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZEGUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:49:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Date: Thu, 7 May 2009 22:47:44 +0200
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A03451E.9020304@gmail.com> <200905072242.49316.arnd@arndb.de>
In-Reply-To: <200905072242.49316.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072247.44925.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19mDsu2944C6YnJHNqpfc8l3YbkkFuyRwwT4mL
 qJyuFJC+PuTCS44vISJ+OA/SCW35uqEh1IkLNmBz7T4DU542Mb
 GG0lz4auBpikF+M5UTW3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Arnd Bergmann wrote:
> An easy way to deal with the pass-through case might be to actually use
> __raw_writel there. In guest-to-guest communication, the two sides are
> known to have the same endianess (I assume) and you can still add the
> appropriate smp_mb() and such into the code.

Ok, that was nonsense. I thought you meant pass-through to a memory range
on the host that is potentially shared with other processes or guests.
For pass-through to a real device, it obviously would not work.

	Arnd <><
