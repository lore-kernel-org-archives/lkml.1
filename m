Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZDTQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZDTQPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 12:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZDTQPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 12:15:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36883 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbZDTQPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:15:33 -0400
Subject: Re: [PATCH V3] Fix Committed_AS underflow
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@linux.vnet.ibm.com,
       cl@linux-foundation.org
In-Reply-To: <1240218590-16714-1-git-send-email-ebmunson@us.ibm.com>
References: <1240218590-16714-1-git-send-email-ebmunson@us.ibm.com>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 09:15:20 -0700
Message-Id: <1240244120.32604.278.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 10:09 +0100, Eric B Munson wrote:
> 1. Change NR_CPUS to min(64, NR_CPUS)
>    This will limit the amount of possible skew on kernels compiled for very
>    large SMP machines.  64 is an arbitrary number selected to limit the worst
>    of the skew without using more cache lines.  min(64, NR_CPUS) is used
>    instead of nr_online_cpus() because nr_online_cpus() requires a shared
>    cache line and a call to hweight to make the calculation.  Its runtime
>    overhead and keeping this counter accurate showed up in profiles and it's
>    possible that nr_online_cpus() would also show.



-- Dave

