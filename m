Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZCBILR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZCBILR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZCBILG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:11:06 -0500
Received: from ns.suse.de ([195.135.220.2]:36790 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbZCBILF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:11:05 -0500
Message-ID: <49AB948E.1070706@suse.de>
Date: Mon, 02 Mar 2009 09:10:54 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Seidel <frank@f-seidel.de>, kernalert.de@gmail.com
Subject: Re: [PATCH] lkdtm: reduce stack size
References: <49AAE94E.8080308@suse.de> <20090302041148.GA7410@in.ibm.com>
In-Reply-To: <20090302041148.GA7410@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ankita Garg wrote:
> The intention here is infact to trigger a stack overflow. This module is
> used to test kernel dumping mechanism like kdump. So the expectation is
> that the kernel will dump as soon as the stack overflows.

Oh, i see. Then this patch of course doesn't make sense.

Thanks,
Frank
