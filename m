Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYEFLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYEFLjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYEFLjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:39:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYEFLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:39:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 24/56] microblaze_v2: time support
Date: Tue, 6 May 2008 13:38:23 +0200
User-Agent: KMail/1.9.9
Cc: John Williams <john.williams@petalogix.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <1210033811.5798.188.camel@localhost> <48202C9E.7070800@seznam.cz>
In-Reply-To: <48202C9E.7070800@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061338.24870.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18iJlH2HkWBhY2kmfLCzjRpi18ccR8Rxx94hbE
 OcLrYmILrup/AzxVs9+xUzhIkV2+4rAdX/x2wyAu6LfHlEzsWa
 HuO0ISUUiq/F215gBfyjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008, Michal Simek wrote:
> I saw a lot of comments about files but I have never seen any comments that
> any file is OK.
> Does it mean everything is broken??? I don't think so.

I've commented mostly on the header files defining the ABI. Since my aim
is to have the ABI definition entirely in asm-generic/*.h, every exported
file that has more than one line in it should be changed.

The files that implement the architecture support itself all look good
to me, but since I'm not familiar with the architecture, I'm not trying
to comment on them.

I think you're doing a great job on this. Any patch set of this size that
has been maintained for a long time outside of the kernel goes through this
phase where everyone tells you what to improve, based on their experience,
while everything you do right about the patches is just taken for granted.

Don't let yourself get discouraged by the negative comments, we're really
all just trying to help you do the right thing!

> I'll integrate reported bugs and send microblaze_v3 version.

Ok, thanks!

	Arnd <><
