Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYKEQNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYKEQNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYKEQN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:13:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54891 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYKEQN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:13:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: arm checkstack
Date: Wed, 5 Nov 2008 17:13:14 +0100
User-Agent: KMail/1.9.9
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
       Linux Arm Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
References: <49107304.2060006@parrot.com> <20081104173524.GB16036@logfs.org>
In-Reply-To: <20081104173524.GB16036@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811051713.15352.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18NB3UFGBzBKmG03z1TrTF1kY3qYOTWcFO6eZn
 OIKGrjiGuchypfFD/XJZC+WMhnqplNlIStrFVZ94FxYmTKmy+m
 wKbQiYLVrGbU5B+mP+9gw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008, Jörn Engel wrote:
> On Tue, 4 November 2008 17:06:28 +0100, Matthieu CASTET wrote:
> > 
> > I wonder why the arm version of checkstack only catch stack size >= 300
> > and < 10000 [1].
> > Why doesn't it use ".*sub.*sp, sp, #([0-9]{1,8})" to catch all stack usage ?
> 
> Looks like a bug.  And it further looks like Holger just copied what
> everyone else did at the time.  And the one who started this strange
> pattern was: Arnd.
> 
> Arnd, did you have a good reason for choosing the pattern?
> 

don't really remember what I thought back then. Probably I tried to filter
out any function lower than 300 bytes as early as possible and did not think
of the >= 10000 case.

	Arnd <><
