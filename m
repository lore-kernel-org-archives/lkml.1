Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZKFCPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZKFCPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 21:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759156AbZKFCPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 21:15:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:19895 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759129AbZKFCPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 21:15:23 -0500
X-ExtLoop1: 1
Date: Fri, 6 Nov 2009 10:15:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] page-types: exit early when invoked with
	-d|--describe
Message-ID: <20091106021525.GD21057@localhost>
References: <20091105201846.25492.52935.stgit@bob.kio> <20091105202126.25492.84269.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105202126.25492.84269.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  		case 'd':
> -			opt_no_summary = 1;
>  			describe_flags(optarg);
> -			break;
> +			exit(0);
>  		case 'l':
>  			opt_list = 1;
>  			break;
 
Good catch, thanks!

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
