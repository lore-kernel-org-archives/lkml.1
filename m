Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYESQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYESQDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYESQC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:02:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbYESQCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:02:55 -0400
Date: Mon, 19 May 2008 12:01:55 -0400
From: Rik van Riel <riel@redhat.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 04/14] free swap space on swap-in/activation
Message-ID: <20080519120155.6c88812f@bree.surriel.com>
In-Reply-To: <4831741A.7090206@gmail.com>
References: <20080516183207.361608893@redhat.com>
	<20080516183224.259161900@redhat.com>
	<4831741A.7090206@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 21:35:38 +0900
MinChan Kim <minchan.kim@gmail.com> wrote:

> I don't know where to send this patch. you or mm ?
> I guess VM pageout patches didn't send mm-commits yet.

If Andrew merges the patches, this could go in as an additional
fix.  If Andrew does not merge the patches, I will queue it up
in my tree for the next submission :)
 
> It made compile error in my system that didn't have swap device. 

Good catch.  Thank you for this compile fix with CONFIG_SWAP=n

-- 
All rights reversed.
