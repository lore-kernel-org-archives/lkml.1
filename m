Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYAFLzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYAFLzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 06:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYAFLzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 06:55:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43686 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYAFLzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 06:55:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780C15C.2000904@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 12:54:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com>
In-Reply-To: <47801126.7020807@oracle.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Sam Ravnborg wrote:
>> On Sat, Jan 05, 2008 at 11:03:30PM +0200, Adrian Bunk wrote:
>>> For kconfig users, "select" is _much_ better than sending them
>>> through different menus.
>> Only if used within the current limitations of Kconfig.
>> And that requires you to use select only to select symbols with
>> no dependencies.
> 
> Right.  One of the main (or maybe even the only) problem(s) is
> that select does not follow dependency chains.
> and that no one works on that problem.
> 
>> In this case we do not know if BLOCK is enabled or not.
> 
> For Aunt Tillie cases, "select" makes sense.  For other cases,
> I'd argue that it makes sense for config users to know when they
> do something that causes an entire subsystem to be added to their
> kernel (like SCSI or NET).

Besides the issue of additional potentially unsatisfied dependencies and
the issue of things being enabled behind the user's back --- there is
another issue which Adrian and Al ignore:

The user who wants to enable usb-storage /has/ to go into the SCSI menu
anyway to answer whether he needs sd, sr, st, sg, command logging...
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
