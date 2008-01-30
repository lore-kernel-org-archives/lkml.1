Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYA3DJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYA3DJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYA3DJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:09:06 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33108 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYA3DJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:09:05 -0500
Date: Tue, 29 Jan 2008 19:25:53 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap
In-reply-to: <200801300357.54924.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291925.53726.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801291116.31729.yinghai.lu@sun.com> <200801300357.54924.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 06:57:54 pm Andi Kleen wrote:
> On Tuesday 29 January 2008 20:16, Yinghai Lu wrote:
> > [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap
> >
> > otherise early_node_mem will use up these for 8 nodes system
> 
> Yes this was the problem with my early_reserve node bootmem patch.
> It adds a node limit.
> 
> But even with increasing the limit is far too small. Probably best to not 
> use the patch. In theory it should not have been needed anyways because
> there is no need to reserve here because there are no interfering users.
> 
> Whatever your problem is it needs to be solved differently.

ok, discard 3, and 4.

how about 2 v2?

YH
