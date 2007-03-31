Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbXCaJsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbXCaJsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 05:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXCaJsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 05:48:39 -0400
Received: from eazy.amigager.de ([213.239.192.238]:43905 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXCaJsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 05:48:39 -0400
Date: Sat, 31 Mar 2007 11:46:32 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070331094631.GA24220@thinkpad.home.local>
Mail-Followup-To: Chuck Ebbert <cebbert@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
References: <20070306164447.GC3661@duck.suse.cz> <20070330045923.GA5528@dose.home.local> <460D51AA.2080307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460D51AA.2080307@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 14:06:34 -0400, Chuck Ebbert wrote:
> Tino Keitel wrote:
> > On Tue, Mar 06, 2007 at 17:44:47 +0100, Jan Kara wrote:
> >>   Hello,
> >>
> >>   the patches attached to six following emails implement some cleanup and
> >> fixes in the UDF code. The main two fixes are:
> >>   1) UDF now works correctly for files larger than 1GB.
> > 
> > Hi,
> > 
> > I tried 2.6.20 with your patches and got the following behaviour:
> > 
> > $ ls -la dvd.udf 
> > -rw-r--r-- 1 root root 4699717632 Mar 29 15:36 dvd.udf
> > $ mount -o loop -t udf dvd.udf /media/udf/
> > $ df /media/udf/
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /home/storage/dvd.udf
> >                        4588506 -8584746354 8589334860   -  /media/udf
> >                                ^^^^^^^^^^^^^^^^^^^^^^
> > $ ls -la /media/udf/
> > total 4587521
> > drwxr-xr-x 3 root root        144 Mar 29 15:36 .
> > drwxr-xr-x 9 root root       1024 Mar 20 12:02 ..
> > -rw-r--r-- 1 root root 4697620480 Mar 29 15:57 bk_usr.tar
> > drwxr-xr-x 2 root root         40 Mar 29 15:36 lost+found
> > 
> 
> Is that on a 32-bit machine?

Yes, it's an Intel Core Duo.

Regards,
Tino
