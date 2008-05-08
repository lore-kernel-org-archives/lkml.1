Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYEHEzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYEHEzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYEHEzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:55:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYEHEzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:55:05 -0400
Date: Thu, 8 May 2008 00:54:15 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 00/15] VM pageout scalability improvements (V6)
Message-ID: <20080508005415.73e611b9@bree.surriel.com>
In-Reply-To: <20080428181835.502876582@redhat.com>
References: <20080428181835.502876582@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 14:18:35 -0400
Rik van Riel <riel@redhat.com> wrote:

> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.

> This patch series improves VM scalability by:

> An all-in-one patch can be found at:
> 
> 	http://people.redhat.com/riel/splitvm/

I have prepared kernel RPMs with the split LRU patch series and
made them available at the above URL.  The kernel packages are
based on the 2.6.25 Fedora 9 kernel RPM.

-- 
All rights reversed.
