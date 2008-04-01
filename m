Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYDAWUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYDAWUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYDAWU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:20:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27785 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYDAWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:20:26 -0400
Date: Tue, 1 Apr 2008 15:18:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix kernel thread names that might offend users.
Message-Id: <20080401151859.e6e16d58.randy.dunlap@oracle.com>
In-Reply-To: <87r6dps3db.fsf@saeurebad.de>
References: <87r6dps3db.fsf@saeurebad.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2008 22:54:08 +0200 Johannes Weiner wrote:

> More and more GNOME users (especially Ubuntu) get confused by their
> process list showing several process names that seem to indicate
> KDE-related services.

so s/offend/confuse/


> To settle things down a bit on the bugtrackers, this patch renames all
> offending kernel threads into something that goes better with
> GNOME-based systems.
> 
> Since KDE is essentially dead, the thread-names are not made
> compile-time configurable but rather just renamed completely here to
> fit modern distributions. 

but, but, the 'k' means kernel.  Is that so bad?


and [OT], why is KDE essentially dead?


> ---
> 
> Please note that these hard-coded names are going to be removed soon
> completely in another patch series that makes kernel thread names more
> `themable' in the sense that users may supply a format string in
> /proc/sys/kernel/kthread_fmt which allows having customizable names
> like "-=[acpid]=-" or similar.

WHY?  Just eye candy + bloat in the kernel?

> Also, please let me know if I forgot something. 

---
~Randy
