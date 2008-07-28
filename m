Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYG1QnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYG1QnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbYG1QnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:43:06 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:43379 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbYG1QnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:43:04 -0400
Message-ID: <488DF70E.20404@nortel.com>
Date: Mon, 28 Jul 2008 10:42:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: luis6674@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: How to disable group scheduler correctly?
References: <842240.12654.qm@web53310.mail.re2.yahoo.com>
In-Reply-To: <842240.12654.qm@web53310.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2008 16:42:58.0565 (UTC) FILETIME=[FE04CB50:01C8F0D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Gonzalez wrote:

> [1] For example, in Arch Linux the group scheduler was first enabled
> in 2.6.25, but due to latency issues it was quickly disabled. But
> after that, the following report claims to have problems with
> everything *GROUP* disabled and that you need to enable CGROUPS to
> solve them (the report links to similar reports on Gentoo and Ubuntu,
> so it seems the confusion is quite general):
> 
> http://bugs.archlinux.org/task/10512

The linked thread talks about latency problems in the CFQ I/O scheduler, 
not the process scheduler.  It appears that enabling CGROUPS helps get 
around the I/O scheduler issues.

Are you sure that you actually want to disable group scheduling for 
processes?

Chris
