Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZHDMqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZHDMqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZHDMqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:46:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbZHDMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:46:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timo Sirainen <tss@iki.fi>
Subject: Re: rename() a directory over a symlink
Date: Tue, 4 Aug 2009 14:46:35 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
References: <1249338691.1216.136.camel@timo-desktop>
In-Reply-To: <1249338691.1216.136.camel@timo-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908041446.35126.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Z82WUSiuSRk4szuEzf9XQIdpVxC72unfi7v0
 kC2Zk6r7Ei8Wl1uzmBaYlyR5qIcWOpEW7rD4Se1SQF2ear/VKQ
 KNGT6IIi2FhcftfQRlJlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, you wrote:
> Is there a reason why it's not allowed? Would it be difficult to
> implement it? Seems like it shouldn't be much different from renaming a
> file over a symlink.

It's in the standard we are following,
http://www.opengroup.org/onlinepubs/009695399/functions/rename.html:

"If the old argument points to the pathname of a directory, the new argument shall
 not point to the pathname of a file that is not a directory."

http://www.opengroup.org/onlinepubs/009695399/utilities/mv.html:

"In the second synopsis form, mv shall move each file named by a source_file
 operand to a destination file in the existing directory named by the target_dir
 operand, or referenced if target_dir is a symbolic link referring to an existing
 directory. The destination path for each source_file shall be the concatenation
 of the target directory, a single slash character, and the last pathname
 component of the source_file. This second form is assumed when the final operand
 names an existing directory."

	Arnd <><
