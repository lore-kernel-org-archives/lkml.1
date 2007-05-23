Return-Path: <linux-kernel-owner+w=401wt.eu-S934785AbXEWToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785AbXEWToU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEWToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:44:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:63894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbXEWToG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:44:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,571,1170662400"; 
   d="scan'208";a="89840447"
Message-ID: <46549937.1030306@linux.intel.com>
Date: Wed, 23 May 2007 12:42:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
References: <200705231510.52932.rob@landley.net>
In-Reply-To: <200705231510.52932.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> I notice that feature-removal-schedule.txt has CONFIG_FORCED_INLINING 
> scheduled to go away most of a year ago.  My question is what replaces it:
> 
> Does #define inline __always_inline become the new standard and uses of 
> __always_inline be removed, or should all instances of "inline" either be 
> removed or replaced with __always_inline?  (Or are there going to be two 
> keywords meaning exactly the same thing going forward?)

it should be that we do not force gcc to inline on the "normal" inline 
keyword, and we mark the cases that HAVE to be inlined for correctness 
reasons as __always_inline.
