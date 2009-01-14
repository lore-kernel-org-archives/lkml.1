Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbZANMAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbZANMAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761692AbZANL76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:59:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761657AbZANL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:59:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philippe De Muyter <phdm@macqel.be>
Subject: Re: linux kernel without file system
Date: Wed, 14 Jan 2009 12:59:49 +0100
User-Agent: KMail/1.9.9
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel>
In-Reply-To: <20090114093422.GA9771@frolo.macqel>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141259.50237.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18SWhM3AkBSMtlYiIDFwOr8sXUvbD3Lc7kC5pf
 uaiJdwjgyfCbwnc69TA9yYP58II1XuJ/SQAnOyc6nUG4QFdBSa
 72/NEWRIUMYTiszvR0GBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009, Philippe De Muyter wrote:
> Actually, I was thinking about reducing the footprint of my kernel by
> removing all the fs-related system calls, so the problem is not where
> the file-system is, but how to access (serial) devices without giving their
> "/dev/..." name.

One thing that you can do is remove support for block devices in somewhat
recent kernels, which gets you most of the way. File systems themselves
are required for the majority of all system calls (anything that takes
a file descriptor) and for the boot process.

	Arnd <><
