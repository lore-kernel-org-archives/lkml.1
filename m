Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXGWQb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXGWQb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760912AbXGWQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:31:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53334 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759769AbXGWQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:31:44 -0400
Date: Mon, 23 Jul 2007 09:35:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: where is the code for read system call?
Message-Id: <20070723093520.16f97256.randy.dunlap@oracle.com>
In-Reply-To: <200707231801.32334.fzu@wemgehoertderstaat.de>
References: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
	<200707210208.44698.fzu@wemgehoertderstaat.de>
	<A3258B497F1C1441AD36A2E8B45FD62858D1FD@scsmsx412.amr.corp.intel.com>
	<200707231801.32334.fzu@wemgehoertderstaat.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 18:01:32 +0200 Karsten Wiese wrote:

> Am Montag, 23. Juli 2007 schrieb Agarwal, Lomesh:
> > For future how do I trace a system call to a function in a kernel?
> 
> strace. i.e:
> 	$ strace ls

I thought (maybe I misunderstood) that Lomesh wanted to know
which kernel function (by name) is called for specific syscalls...
and strace will tell the syscall by name, but not the kernel
function names.

If Lomesh wants what I described, then the answer is more like
"see the syscall tables in each $ARCH".

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
