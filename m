Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXE2Sx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXE2Sx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbXE2SxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:53:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52816 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbXE2SxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:53:17 -0400
Date: Tue, 29 May 2007 11:59:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1: SLUB
Message-Id: <20070529115900.405908a3.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705291131010.24395@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<20070528212250.eb38af64.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705291012120.23611@schroedinger.engr.sgi.com>
	<465C6D4B.90403@oracle.com>
	<Pine.LNX.4.64.0705291131010.24395@schroedinger.engr.sgi.com>
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

On Tue, 29 May 2007 11:32:27 -0700 (PDT) Christoph Lameter wrote:

> Oh. I forgot the usual instruction: Try to boot with slub_debug on the 
> kernel command line. SLUB will attempt to remedy the situation to allow 
> the boot to continue if it finds anything that goes wrong.

Yes, that boots, thanks.

Problem was the dmi-off-by-one kmalloc.  I used the patch
that Andrew has merged and it works fine now.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
