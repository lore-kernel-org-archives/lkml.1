Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYEDTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYEDTw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYEDTwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:52:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbYEDTwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:52:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 07/56] microblaze_v2: Signal support
Date: Sun, 4 May 2008 21:52:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
In-Reply-To: <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805042152.07486.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18dkqVfZz0S7HHU8QdRxk6KqbfHpAJKEz/nYbq
 G7/E80eTnKqB9RePXmvazincM1/wNW+cQJXOod/P8OvMbaaJuy
 QSUVQq4V0F7MPhvYPOAdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

This patch should have a comment saying that it will mostly go away
with the new syscall interface, with the one exception of
sys_rt_sigreturn().

	Arnd <><
