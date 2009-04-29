Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZD2Rme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZD2Rme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZD2RmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:42:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48977 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZD2RmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:42:24 -0400
Date: Wed, 29 Apr 2009 18:41:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090429174154.GK8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <884894.99151.qm@web32602.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <884894.99151.qm@web32602.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:24:20AM -0700, Martin Knoblauch wrote:

> > Er...  Somebody mounting sysfs twice?  From some init script and from
> > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > have been done to cause that...
> 
>  One definitely comes from /etc/fstab, but I am not aware of any other script mounting sysfs in my userspace.

Check in /etc/init.d; e.g. on debian it's mountkernfs.  More interesting
question is what else is mounted on /sys; how about the entire /proc/mounts
contents?
