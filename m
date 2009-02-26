Return-Path: <linux-kernel-owner+w=401wt.eu-S1764237AbZBZAF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764237AbZBZAF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758751AbZBZADI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:03:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:64934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763780AbZBZADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:03:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Make exported headers use strict posix types
Date: Thu, 26 Feb 2009 01:01:30 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225201131.GA26110@uranus.ravnborg.org> <49A5CF2E.6050306@zytor.com>
In-Reply-To: <49A5CF2E.6050306@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902260101.31580.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+c2Eim4THXOXybpKW00QAOFRZsPL1xCYWfja9
 E3DOO43ct1o1PQVFp1OmJ+0Oj52hfn19tsW41A7cESZo8STeNv
 s4kq/MYbxopO+hFZqifwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >>
> >> This is my previous patch, ported to today's git. It's my last day
> >> before my vacation, so I can't do the usual testing etc. on it.
> >> Hopefully somebody else can take care of this.
> > 
> > I hesitate to put it in kbuild.git... Any better place?
> > 
> 
> I'll put it in tip:core/headers-fixes.

Just in the minute I notice a bug :(

Unfortunately, I mistakenly replaced uid_t with __kernel_uid_t when
it had to be __kernel_uid32_t. New series follows, including the
changes for all integer types.

	Arnd <><
