Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZCXN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZCXN5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZCXN5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:57:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbZCXN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:57:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 44/57] microblaze_v7: termbits.h termios.h
Date: Tue, 24 Mar 2009 14:57:28 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Remis Lima Baima <remisbaima@gmail.com>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <200903232037.23768.arnd@arndb.de> <49C8C1FB.2090608@monstr.eu>
In-Reply-To: <49C8C1FB.2090608@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241457.29431.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19XRbkPDIW6iGLHxUVAtf1IwWzsfnWn7n9pnLK
 CayujlTE7IAm7XDFzVEGmTL7IGTDfOtTF08FzegTj495S35rqG
 w+J+JtGHuoytwoAjMJswg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009, Michal Simek wrote:
> > I haven't gotten around to posting them for review, but I still think
> > it would be great if we can at least make sure they are identical
> > so we can remove your versions as soon as we have the asm-generic ones.
> 
> I tested it some min ago. I just take your termios.h and termbits.h from
> asm-generic folder. I miss there only #include <asm/uaccess.h> in termion.h.
> 
> Compilation is OK and kernel works with your files too. For me is easy to use
> your version. If they are there, I'll use them.

Ok. I did not just mean these specific files, but all the headers in
general. I assume that you have not had a chance to look into the
other header files, which is ok. Remis is currently cleaning up bits
of the generic header files in Linux based on my work, and I asked
him to look into your tree to see how much can be shared.

Note that there is a problem of binary compatibility with certain headers.
If e.g. the constants from termbits.h or some data structures slightly
change, user space will still compile but no longer be compatible
with other kernel versions, so this needs to be done very carefully.

	Arnd <><
