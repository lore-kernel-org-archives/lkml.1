Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYBXKqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYBXKqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYBXKqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:46:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:61110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYBXKqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:46:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC 01/11] add generic versions of debugfs file operations
Date: Sun, 24 Feb 2008 11:46:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
References: <20080219040435.825494460@arndb.de> <20080219040828.415218298@arndb.de> <20080223122444.GM27894@ZenIV.linux.org.uk>
In-Reply-To: <20080223122444.GM27894@ZenIV.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241146.08360.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/3rdNOsxvyAp+yeumgJImBwLh6hXcE3yty2tw
 xE01041Bm8ItUiN0voM67BC1TEfOZhgcj8KKNG9aOLpHPqlyr0
 5iSBD7XbsRikQ/+zuZpRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, Al Viro wrote:

> Ewww - caps, \n...  BTW, \0 is pointless here - simple_read_from_buffer() will
> not access it with these arguments)...

> ... 

> Please, check the length; sloppy input grammar is a bad idea.  Hell, at the
> very least you want -EINVAL if input is not recognized...

Ok, these two come straight from debugfs, but of course I can fix them
anyway. Should I do a fix for debugfs in 2.6.25 first, or rather do a
patch on top of the libfs rework?

I'd rather not have any semantic changes during the conversion, so
it would be better to keep that separate imho.

	Arnd <><
