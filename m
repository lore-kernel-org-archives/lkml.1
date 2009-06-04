Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZFDImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZFDImI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZFDIl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:41:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbZFDIl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:41:56 -0400
Date: Thu, 4 Jun 2009 01:40:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-Id: <20090604014031.01968da3.akpm@linux-foundation.org>
In-Reply-To: <4A27853F.8060109@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	<20090602114402.951631599@linux.vnet.ibm.com>
	<20090602150324.c706b1d2.akpm@linux-foundation.org>
	<4A266546.5080601@linux.vnet.ibm.com>
	<4A26961E.7040207@linux.vnet.ibm.com>
	<20090603143923.a5387555.akpm@linux-foundation.org>
	<4A27853F.8060109@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jun 2009 10:26:39 +0200 Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> Ah, right. That answers my question whether further changes should be 
> posted as complete or incremental patches.

yup.  Incrementals are a bit more hassle, but they're hugely more
friendly to people who have already reviewed the code.

And occasionally when I turn a replacement patch into an incremental,
it shows up things which the submitter hadn't intended be included.

> is it ok to post many small 
> patches for -mm for minor changes like this one (simple_ -> strict_) or 
> do you rather prefer these to be collected into somewhat larger patches 
> that fix multiple minor issues?

I think one patch per "issue" would be best.  Although combo patches at
this stage would not be a huge problem.
