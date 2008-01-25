Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbYAYInW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbYAYInW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764449AbYAYIDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:03:55 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45107 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764435AbYAYIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:03:54 -0500
Date: Fri, 25 Jan 2008 09:03:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
In-Reply-To: <20080124210431.GA1647@Krystal>
Message-ID: <Pine.LNX.4.64.0801250900400.12676@fbirervta.pbzchgretzou.qr>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca>
 <20080124125845.bf5767b8.randy.dunlap@oracle.com> <20080124210431.GA1647@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 16:04, Mathieu Desnoyers wrote:
>* Randy Dunlap (randy.dunlap@oracle.com) wrote:
>
>Try opening such code in vim, and the syntax highlighting gets all
>messed up :-/

Then we'd also have to fix dcache.h:

#define DCACHE_NFSFS_RENAMED  0x0002    /* this dentry has been "silly 
                                         * renamed" and has to be 
                                         * deleted on the last dput() 
                                         */ 

by adding \ at the end of the comments, to unbreak cooledit and mc.
(The problem is not the comment, but the seemingly stray " in the 2nd line)
