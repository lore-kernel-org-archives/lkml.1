Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZDPQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZDPQvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZDPQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:51:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbZDPQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:51:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: last remaining asm/ header moves: h8300 and m32r
Date: Thu, 16 Apr 2009 18:49:25 +0200
User-Agent: KMail/1.9.9
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, takata@linux-m32r.org,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
References: <20090416150707.GA941@lst.de>
In-Reply-To: <20090416150707.GA941@lst.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161849.26417.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19eg10ujoSQB4AJVIrnAHDtY5F3XlY8lwF1Q35
 opYj2VwvwXofqPTZTDUZ7xTXd3tq5Ss8gNvc2AlvYOmNSCypJ6
 tNyye93mWW3AM8c4RXyhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009, Christoph Hellwig wrote:

> h8300 and m32r are the last two architectures still having their asm/
> headers in include/ instead of arch/$arch/include.  Any chance you could
> do the move for 2.6.30 so we're only left with one way of doing it?

Seconded. Note that Linus has already done the move himself for
h8300 back in August, but a new timer.h file was added in a patch
that got merged at the same time, so the directory is there again,
with a single file in it.

	Arnd <><
