Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYAEXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYAEXqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 18:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYAEXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 18:46:12 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53503 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbYAEXqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 18:46:11 -0500
Date: Sun, 6 Jan 2008 01:45:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080105234540.GG22232@does.not.exist>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47801126.7020807@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 03:22:14PM -0800, Randy Dunlap wrote:
>...
> For Aunt Tillie cases, "select" makes sense.  For other cases,
> I'd argue that it makes sense for config users to know when they
> do something that causes an entire subsystem to be added to their
> kernel (like SCSI or NET).

We are not talking about Aunt Tillie [1] since she anyway does not build 
her own kernel.

The vast majority of kconfig users should be covered by the
"system administrator" use case. And for them it's a lot easier if they 
simply find the options for their hardware in the logical places without 
additional hassle.

Whether or not an option requires an additional subsystem like e.g. SCSI 
or SSB are hardware and implementation details we shouldn't bother 
kconfig users with.

cu
Adrian

[1] kconfig version of Godwin's law

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

