Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbXELKjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbXELKjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXELKjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:39:37 -0400
Received: from as3.cineca.com ([130.186.84.211]:34004 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbXELKjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:39:36 -0400
Message-ID: <46459959.6020802@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       wli@holomorphy.com, dada1@cosmosbay.com, pavel@ucw.cz,
       linas@austin.ibm.com, msyrchin@ru.mvista.com
Subject: Re: [PATCH] Performance Stats: Kernel patch
References: <20070511171308.9897.93893.stgit@localhost.localdomain>
In-Reply-To: <20070511171308.9897.93893.stgit@localhost.localdomain>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Date: Sat, 12 May 2007 12:39:31 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Uvarov wrote:
> diff --git a/Documentation/accounting/taskstats-struct.txt b/Documentation/accounting/taskstats-struct.txt
> index 661c797..606aef6 100644
> --- a/Documentation/accounting/taskstats-struct.txt
> +++ b/Documentation/accounting/taskstats-struct.txt
> @@ -22,6 +22,8 @@ There are three different groups of fields in the struct taskstats:
>      /* Extended accounting fields end */
>      Their values are collected if CONFIG_TASK_XACCT is set.
>  
> +4) Per-task and per-thread statistics
> +
>  Future extension should add fields to the end of the taskstats struct, and
>  should not change the relative position of each field within the struct.
>  
> @@ -158,4 +160,9 @@ struct taskstats {
>  
>  	/* Extended accounting fields end */
>  
> +4) Per-task and per-thread statiscits

...a small typo in the documentation: s/statiscits/statistics/

-Andrea
