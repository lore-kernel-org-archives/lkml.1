Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZHJQYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZHJQYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZHJQYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:24:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZHJQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:24:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Date: Mon, 10 Aug 2009 18:24:29 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Martin Schwidefsky <schwidefsky@googlemail.com>,
       Jeff Dike <jdike@addtoit.com>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <20090808010336.GN4999@nowhere> <20090808032058.GA30378@suse.de>
In-Reply-To: <20090808032058.GA30378@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101824.29459.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18krro8pamSEUVVj4pUxJFPbDWhKsP7F6WkT1r
 32lCkw96KWnjFNj0qQ9Jb7QpaqRo6FVmFclDc5/e4luEWMbQMD
 rJeL/lpb+LqPsYYG7dK9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009, Greg KH wrote:
> sure, someone want to send them all to me after getting the other
> subsystem's acks?

Yes, sounds good. 

Martin and Jeff, could you have a look at the first two patches?

The final patch is not tty specific, but it still depends on
the others, so I guess you can take that one as well. It could
use an extra pair of eyeballs though, just to see if my logic
was correct, the impact should be rather significant.

	Arnd <><
