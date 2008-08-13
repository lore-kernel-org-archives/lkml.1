Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYHMMQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYHMMQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYHMMP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:15:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYHMMPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:15:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "John Kacur" <jkacur@gmail.com>
Subject: Re: drop overzealous ERROR: do not initialise statics to 0 or NULL from checkpatch.pl
Date: Wed, 13 Aug 2008 14:15:36 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, "Andy Whitcroft" <apw@shadowen.org>,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
References: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
In-Reply-To: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808131415.36851.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18g+qB2x1k5SadAa3Xaxp+TdVelkpjAwWVN11y
 y7vNDIbDr4lZs6b+nTqEOdkJEV9NmbSZUTSyF5wTTzn04NGH4m
 mLmbuNjUSOlkdrCc7MDYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, John Kacur wrote:
> Could we drop this somewhat overzealous "ERROR: do not initialise
> statics to 0 or NULL" from checkpatch.pl?

I totally agree we should drop it.

> Reasoning:
> 1. This is not part of Documentation/CodingStyle

However, it is in http://kernel-janitor.sourceforge.net/TODO and should
be dropped from there as well.

> 3. It can be a good form of documentation.

I don't think so. Every C programmer should know that it is the
same. 

> 5. It doesn't even change the object size (thus kernel size) to do so.
> Demo with user space code.

I'm not sure what the last compiler version was on which it made the
difference, probably 2.95 or 3.0 or something else that is no longer
supported.
I do remember that at some point in time, we could save a few bytes by
doing it.

	Arnd <><
