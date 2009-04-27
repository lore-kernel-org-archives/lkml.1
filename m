Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbZD0QZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbZD0QZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZD0QZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:25:18 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:44659 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZD0QZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:25:16 -0400
Date: Mon, 27 Apr 2009 12:15:37 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Eric B Munson <ebmunson@us.ibm.com>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH] Display 0 in meminfo for Committed_AS when value
 underflows
In-Reply-To: <1240848914.29485.52.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0904271214580.31916@qirst.com>
References: <1240848620-16751-1-git-send-email-ebmunson@us.ibm.com> <1240848914.29485.52.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Dave Hansen wrote:

> Yeah, this is the right fix for now until we can iron out the base
> issues.  Eric, I think this may also be a candidate for -stable.

Is there any way you could use a ZVC there? Those already have the
underflow prevention logic. See include/linux/vmstat.h and mm/vmstat.c
