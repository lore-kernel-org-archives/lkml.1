Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXFVE5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXFVE5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXFVE51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:57:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12750 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXFVE50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:57:26 -0400
Date: Thu, 21 Jun 2007 21:57:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joshua Wise <jwise@google.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, thockin@google.com,
       akpm@google.com
Subject: Re: [PATCH] x86_64: Fix misplaced `continue' in mce.c
Message-Id: <20070621215758.a6ce4002.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0706211706270.30728@internets.corp.google.com>
References: <Pine.LNX.4.64.0706211706270.30728@internets.corp.google.com>
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

On Thu, 21 Jun 2007 17:13:49 -0700 (PDT) Joshua Wise wrote:

> Testing:
>   On my system, I could replicate the bug with the following command:
>     # for i in `seq 15000`; do ./inject_sbe.sh; done
>   where inject_sbe.sh contains commands to inject a single-bit error into the
>   next memory write transaction.

Hi,

Does inject_sbe.sh require special hardware?  If so, what hardware
is it?

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
