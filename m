Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXCSSus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXCSSus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXCSSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:50:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXCSSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:50:47 -0400
Date: Mon, 19 Mar 2007 10:50:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Alex Tomas <alex@clusterfs.com>
Subject: Re: 2.6.21-rc3-mm2: PG_booked and PG_readahead
Message-Id: <20070319105009.58c99280.akpm@linux-foundation.org>
In-Reply-To: <45FEC5F4.8090906@shadowen.org>
References: <45FEC5F4.8090906@shadowen.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:18:44 +0000 Andy Whitcroft <apw@shadowen.org> wrote:

> [applogies in advance if this has already been asked]
> 
> I note that PG_booked and PG_readahead are both using bit 20 in
> 2.6.21-rc3-mm2.  Is this intentional or perhaps a miss-merge.  They do
> not sound obviously non-overlapping to my mind.
> 

Yes, that's a merging problem - I'll fix it up.  Thanks.
