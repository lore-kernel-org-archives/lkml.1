Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZADAuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZADAuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZADAuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:50:09 -0500
Received: from twin.jikos.cz ([213.151.79.26]:47085 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZADAuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:50:08 -0500
Date: Sun, 4 Jan 2009 01:50:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: eduardo cruz <eduardof_cr@yahoo.com.br>
cc: linux-kernel@vger.kernel.org
Subject: Re: as instructed in REPORTING-BUGS... linux 2.6.28
In-Reply-To: <512956.90094.qm@web39503.mail.mud.yahoo.com>
Message-ID: <alpine.LRH.1.10.0901040148530.2418@twin.jikos.cz>
References: <512956.90094.qm@web39503.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, eduardo cruz wrote:

> as instructed in REPORTING-BUGS, error - compiling linux 2.6.28
> 
> Sumary of the error:
> 
> after kernel and modules have been compiled fine, when running 'make modules_install' I got aways the same result:
> 
> /bin/sh: line 1:  7952 Aborted                 /sbin/depmod -ae -F System.map 2.6.28                     
> make: *** [_modinst_post] Error 134

Please raise this as a bugreport against module-init-tools (which is the 
package containing depmod binary).

-- 
Jiri Kosina
SUSE Labs

