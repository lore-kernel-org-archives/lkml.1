Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYB0Pd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYB0Pd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYB0PdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:33:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYB0PdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:33:20 -0500
Date: Wed, 27 Feb 2008 10:30:55 -0500
From: Rik van Riel <riel@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Message-ID: <20080227103055.2267b50c@bree.surriel.com>
In-Reply-To: <alpine.DEB.1.00.0802262315030.11433@chino.kir.corp.google.com>
References: <47C4F9C0.5010607@linux.vnet.ibm.com>
	<alpine.DEB.1.00.0802262201390.1613@chino.kir.corp.google.com>
	<20080227160746.425E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<alpine.DEB.1.00.0802262315030.11433@chino.kir.corp.google.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 23:19:08 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> My suggestion is merely to make the number of concurrent page reclaim 
> threads be a function of how many online cpus there are.

The more CPUs there are, the more lock contention you want?

Somehow that seems backwards :)

-- 
All rights reversed.
