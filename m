Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZADVxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZADVxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZADVxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:53:25 -0500
Received: from mout-xforward.kundenserver.de ([212.227.17.6]:49623 "EHLO
	mout-xforward.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbZADVxY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:53:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Sun, 4 Jan 2009 22:52:44 +0100
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20090103195034.GA27541@infradead.org> <1231013856.7538.89.camel@think.oraclecorp.com>
In-Reply-To: <1231013856.7538.89.camel@think.oraclecorp.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901042252.45054.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/9JwqENiLmGkHfP64+cFoXOBHqkH+8cF6Vev1
 7XpZX2vnsb4brwY5IANBawj5UoSAXekY3K1v2H2lCkF5MCKsI4
 Bs1YKsbT8TlUjXxBkwqkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009, Chris Mason wrote:
> 
> > Actually a lot of the ioctl API don't just need documentation but
> > a complete redo.  That's true at least for the physical device
> > management and subvolume / snaphot ones.
> > 
> 
> The ioctl interface is definitely not finalized.  Adding more vs
> replacing the existing ones is an open question.

As long as that's an open question, the ioctl interface shouldn't get
merged into the kernel, or should get in as btrfsdev, otherwise you
get stuck with the current ABI forever.

Is it possible to separate out the nonstandard ioctls into a patch
that can get merged when the interface is final, or will that make
btrfs unusable?

	Arnd <><
