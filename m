Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbXEVATV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbXEVATV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbXEVAS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:18:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18803 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbXEVAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:18:58 -0400
Date: Mon, 21 May 2007 17:23:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: error in recent patch to fs/partitions/ldm.c
Message-Id: <20070521172300.b1e9da3b.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705211923270.1886@localhost.localdomain>
References: <Pine.LNX.4.64.0705211923270.1886@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 19:24:57 -0400 (EDT) Robert P. J. Day wrote:

> 
> $ git show dde33348e53ecab687a9768bf5262f0b8f79b7f2
> ...
> --- a/fs/partitions/ldm.c
> +++ b/fs/partitions/ldm.c
> ...
> -                       (unsigned long long)ph->config_size );
> +                       udunsigned long long)ph->config_size);
>                         ^^^^^^^^^^

Patch has already been posted to lkml:

From:	Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Fix to the fix! - Re: [2.6 PATCH] LDM: Fix for Windows Vista dynamic disks
Date:	Mon, 21 May 2007 21:13:37 +0100 (BST)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
