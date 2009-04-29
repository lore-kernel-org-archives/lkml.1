Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZD2Rnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZD2Rnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZD2Rnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:43:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49092 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZD2Rnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:43:40 -0400
Date: Wed, 29 Apr 2009 18:43:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Martin Knoblauch <knobi@knobisoft.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090429174323.GL8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <884894.99151.qm@web32602.mail.mud.yahoo.com> <30441.1241026559@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30441.1241026559@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 01:35:59PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 29 Apr 2009 10:24:20 PDT, Martin Knoblauch said:
> 
> >  One definitely comes from /etc/fstab, but I am not aware of any other script
>  mounting sysfs in my userspace.
> 
> You said it was a RedHat box?
> 
> Look in /etc/rc.sysinit:
> 
>         mount -n -t sysfs /sys /sys >/dev/null 2>&1
> 
> (Near line 28 for RHEL 4, line 23 for RHEL5, and line 21 for Fedora Rawhide)
> 
> Probably your culprit.

Again, the interesting question is WTF had mount(2) not failed with -EBUSY

