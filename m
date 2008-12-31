Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYLaRPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYLaRPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYLaRPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:15:23 -0500
Received: from mout-xforward.kundenserver.de ([212.227.17.5]:65431 "EHLO
	mout-xforward.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438AbYLaRPV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:15:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Wed, 31 Dec 2008 18:15:07 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1230364498-31620-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812311815.09031.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/D5hG4/UUD9cihyu/EHZAqPYBCNIlGYzliIfF
 DOeT6F7aLaHHkO/bY9Ff4dX5HMXQxgMg99Qw0+xBIFZ3hrdAik
 IXKhKTr9Yz4aWtWbOFFGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 December 2008, Mike Frysinger wrote:
> Headers in userspace should be using the __xxx__ form of the asm, inline,
> and volatile keywords.  Since people like to revert these things without
> realizing what's going on, have the headers install step autoconvert these
> keywords.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

The patch looks right, but I would argue that most of the instances of
any of these should not be exported in the first place. I'm not
sure whether there is a legitimate use for the byteorder inlines,
but the others I could find look like they are not meant for use by the
kernel.

	Arnd <><
