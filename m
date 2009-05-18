Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZERO6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZERO6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZERO6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:58:47 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50979 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbZERO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:58:46 -0400
Date: Mon, 18 May 2009 10:34:22 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <20090515203122.GM4451@balbir.in.ibm.com>
Message-ID: <alpine.DEB.1.10.0905181033230.6018@qirst.com>
References: <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com>
 <20090514213403.GB14741@elf.ucw.cz> <alpine.DEB.1.10.0905151346550.26559@qirst.com> <1242411307.28257.25.camel@nimitz> <alpine.DEB.1.10.0905151526170.13433@qirst.com> <20090515203122.GM4451@balbir.in.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009, Balbir Singh wrote:

> > But that is a resource control isssue. Should also not say out of memory
> > but state that the cgroup memory limit was reached.
> >
>
> But we are out of memory for the cgroup under consideration.

Not necessarily. This only occurs if the cgroup cannot swap or if
allocations are done that are not swappable.

