Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYJ2Vx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYJ2Vx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYJ2Vw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:52:59 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:51873 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYJ2Vw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:52:58 -0400
Date: Wed, 29 Oct 2008 19:47:06 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] NMI watchdog: add support to enable and disable
 IOAPIC NMI
In-Reply-To: <20081029090532.cc9536d9.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0810291941510.13373@ftp.linux-mips.org>
References: <20081027164233.132189000@napanee.usersys.redhat.com> <20081027164234.679734000@napanee.usersys.redhat.com> <20081029090532.cc9536d9.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Randy Dunlap wrote:

> > This patch adds support to enable/disable IOAPIC NMI watchdog in runtime via
> > procfs.
> 
> Some info on how to use this, what to write(?) to what file(?) in procfs
> would be Very Good to have.

 I gather this is an extension to the existing interface already covering 
the local APIC NMI watchdog, which surely ;) must have been documented at 
the time it was added.  If it wasn't, then we cannot require it now as a 
prerequisite to accept this patch, although such documentation would be 
desirable as a separate submission.

  Maciej
