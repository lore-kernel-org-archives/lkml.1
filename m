Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbZJXEHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbZJXEHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 00:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZJXEHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 00:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZJXEHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 00:07:00 -0400
Message-ID: <4AE27B95.8080605@redhat.com>
Date: Fri, 23 Oct 2009 23:59:17 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: David Rientjes <rientjes@google.com>, Jiri Kosina <jkosina@suse.cz>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: page allocation failure message kernel 2.6.31.4 (tty-related)
References: <20091020153838.665bc39c.skraw@ithnet.com> <alpine.LRH.2.00.0910211848510.20992@twin.jikos.cz> <alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com> <20091022105902.GM11778@csn.ul.ie>
In-Reply-To: <20091022105902.GM11778@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 06:59 AM, Mel Gorman wrote:

> Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> slightly by allowing rt_tasks that are handling an interrupt to set
> ALLOC_HARDER. This patch brings the watermark logic more in line with
> 2.6.30.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
