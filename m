Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXIAWNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXIAWNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbXIAWND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:13:03 -0400
Received: from ns.suse.de ([195.135.220.2]:45272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbXIAWNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:13:01 -0400
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into IDRs
References: <20070831112445.976429000@bull.net>
	<20070831112613.552219000@bull.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:12:57 +0200
In-Reply-To: <20070831112613.552219000@bull.net>
Message-ID: <p73tzqevxue.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia.Derbey@bull.net writes:

> This patch introduces ipcs storage into IDRs. The main changes are:
>   . This ipc_ids structure is changed: the entries array is changed into a
>     root idr structure.
>   . The grow_ary() routine is removed: it is not needed anymore when adding
>     an ipc structure, since we are now using the IDR facility.
>   . The ipc_rmid() routine interface is changed:
>        . there is no need for this routine to return the pointer passed in as
>          argument: it is now declared as a void
>        . since the id is now part of the kern_ipc_perm structure, no need to
>          have it as an argument to the routine
> 

Thanks for doing this work. It was long overdue.

Do you have any data how this changes memory consumption with 
many objects? 

-Andi
