Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXGFHJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXGFHJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762707AbXGFHJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:09:29 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:49716 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbXGFHJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:09:27 -0400
Message-ID: <468DEA8C.6090000@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2007 00:09:00 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [-mm PATCH 0/8] Memory controller introduction (v2)
References: <20070706052029.11677.16964.sendpatchset@balbir-laptop> <468DD969.1040104@linux.vnet.ibm.com>
In-Reply-To: <468DD969.1040104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

In mem_container_move_lists()

> +		/*
> +		 * Check if the meta page went away from under us
> +		 */
> +		if (!list_empty(&mp->list)

You'll need an extra brace here to get it compile.
I forgot to refpatch :(


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
