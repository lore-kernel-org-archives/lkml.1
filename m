Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXFJRt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXFJRt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXFJRtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:49:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46638 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbXFJRts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:49:48 -0400
Date: Sun, 10 Jun 2007 10:50:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, raven@themaw.net
Subject: Re: [PATCH 0/7] Cleanup code to replace DPRINTK with pr_debug
Message-Id: <20070610105024.b16d1708.randy.dunlap@oracle.com>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
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

On Fri, 08 Jun 2007 23:18:31 +0100 Jack Stone wrote:

> This patch series replaces DPRINTK with pr_debug in alternative.c,
> autofs, autofs4
> and ncpfs. A new function called pr_err is also added to keep
> functionality in
> ncpfs. The last 2 patches add support for pr_debug_pid and apply it to
> autofs4 to
> keep the output the same as the current DPRINTK statements.
> 
> All patches have been compile tested but not boot tested

Hi,

Doesn't this move printk-debug control from local source files
(i.e., targeted, specific ones) to a more global control (DEBUG)?

If so, I don't see that as a generally good thing.

If not, please correct me and tell me how this is useful to just
one instance of using pr_debug() in say, ncpfs, without pr_debug()
being enabled throughout the entire kernel tree.

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
