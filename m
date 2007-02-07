Return-Path: <linux-kernel-owner+w=401wt.eu-S1161316AbXBGODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161316AbXBGODo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161318AbXBGODo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:03:44 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:33672 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161316AbXBGODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:03:43 -0500
Date: Wed, 7 Feb 2007 06:03:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andi Kleen <ak@suse.de>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
In-Reply-To: <p73ejp2mfqh.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0702070602221.14056@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
 <p73ejp2mfqh.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, Andi Kleen wrote:

> IMHO there shouldn't be any memory less nodes. The architecture code
> should not create them. The CPU should be assigned to a nearby node instead.
> At least x86-64 ensures that.

Yes I wish we would do it that way on all platforms. SGI's SN2 does that 
too.



