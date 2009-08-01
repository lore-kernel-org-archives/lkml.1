Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZHAFOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZHAFOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 01:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZHAFOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 01:14:03 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:44006 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZHAFOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 01:14:01 -0400
Message-ID: <4A73CF12.4040902@nortel.com>
Date: Fri, 31 Jul 2009 23:13:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jim Paradis <jparadis@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Dirty page tracking & on-the-fly memory mirroring
References: <4A738FFD.8020705@redhat.com>
In-Reply-To: <4A738FFD.8020705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2009 05:13:59.0331 (UTC) FILETIME=[E0580730:01CA1266]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Paradis wrote:
> Following are two patches against 2.6.31-rc3 which implement dirty page 
> tracking and on-the-fly memory mirroring.  The idea is to be able to 
> copy the entire physical memory over to another processor node or memory 
> module while the system is running.  Stratus makes use of this 
> functionality to bring a new partner node online.

We've been using something like this to mirror specific applications.
Our API is a bit different, it's per-process and lets the app specify
memory regions to monitor.  Another task sharing the memory map can
query the system for the addresses of pages that have been dirtied since
it last asked.

Chris
