Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYEQNfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYEQNfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYEQNfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:35:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbYEQNfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:35:40 -0400
Date: Sat, 17 May 2008 09:35:22 -0400
From: Rik van Riel <riel@redhat.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 00/14] VM pageout scalability improvements (V7)
Message-ID: <20080517093522.1371a40e@bree.surriel.com>
In-Reply-To: <482E7246.5070607@gmail.com>
References: <20080516183207.361608893@redhat.com>
	<482E7246.5070607@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 14:51:02 +0900
MinChan Kim <minchan.kim@gmail.com> wrote:
> Rik van Riel wrote:
> > On large memory systems, the VM can spend way too much time scanning
> > through pages that it cannot (or should not) evict from memory. Not
> > only does it use up CPU time, but it also provokes lock contention
> > and can leave large systems under memory presure in a catatonic state.
> > 
> > Against 2.6.25-rc2-mm1
> 
> I think it's typo error. 
> This patch is based on 2.6.26-rc2-mm1. :-)

Yeah, that was a typo.   I just inserted -rc2 after forward
porting the stuff from 2.6.25-mm1 :)

Andrew, the code is against your latest tree and has been
performance tested in a few scenarios. I believe it should
be ready to be merged now.

-- 
All rights reversed.
