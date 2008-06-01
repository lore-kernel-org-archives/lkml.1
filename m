Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYFAUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYFAUFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYFAUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:05:35 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:38249 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYFAUFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:05:34 -0400
Date: Mon, 2 Jun 2008 01:34:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 07/12] second chance replacement for anonymous pages
Message-ID: <20080601200412.GA29444@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lee Schermerhorn <lee.schermerhorn@hp.com>,
	Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <20080529202246.322317334@redhat.com> <20080529202312.502928900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080529202312.502928900@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2008-05-29 16:22:53]:

> From: Rik van Riel <riel@redhat.com>
> 
> +	if (lru == LRU_ACTIVE_ANON &&
> +	    (!scan_global_lru(sc) || inactive_anon_low(zone))) {
>  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;
>  	}

This should do the trick. I was playing around with v8 and came up
with the exact same fix, after having spent some time reviewing and
playing around with the code.

Let me bundle up all of V9 and test it.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
