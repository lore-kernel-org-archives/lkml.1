Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZI3QP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZI3QP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZI3QP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:15:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZI3QP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:15:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Wed, 30 Sep 2009 18:15:44 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
References: <20090924165548.GA16586@us.ibm.com> <alpine.LFD.2.01.0909291501530.6996@localhost.localdomain> <4AC287F2.8060603@zytor.com>
In-Reply-To: <4AC287F2.8060603@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909301815.45211.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX196rVl4yh4hoRg1HWr3q3fdsIbTtu+7WWho0xV
 7bf1MKaLhlbxbTPXivO1rScb8gR4rxrnTKGv2wO6SgGaljAqyF
 cino5DyZ7EhTi6+fRpzVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, H. Peter Anvin wrote:
> Let's just make it another system call.  It doesn't have any downside
> that I can see, might prevent problems, and avoids setting a bad
> precedent that someone can misinterpret.

One more argument for this is that the new code is architecture independent
using user_stack_pointer(), while the original sys_clone is highly
architecture specific, which is a source for bugs when trying to
extend it.

	Arnd <><
