Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYEaUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYEaUlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYEaUlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:41:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYEaUlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:41:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Sat, 31 May 2008 22:40:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <48419F45.20908@davidnewall.com>
In-Reply-To: <48419F45.20908@davidnewall.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805312240.50720.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ziyVm/HuKwb/NMwAaQ7gP0VIDoQpOUvLrVp1
 CmF4KuFZl6hSyn3aFSzsBs26ZK5E7bttg8gqnV+3dvkiF7opI2
 rQnk4V3CjcIz4ND4ZVCNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008, David Newall wrote:
> I don't agree that it is nicer to do this in cramfs.  I prefer the
> technique of union of a tmpfs over some other fs because a single
> solution that works with all filesystems is better than re-implementing
> the same idea in multiple filesystems.  Multiple implementations is a
> recipe for bugs and feature mismatch.

You're right in principle, but unfortunately there is to date no working
implementation of union mounts. Giving users the option of using an
existing file system with a few tweaks can only be better than than
forcing them to use hacks like unionfs.

	Arnd <><
