Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXLQSnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXLQSnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXLQSnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:43:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:22938 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbXLQSnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:43:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,177,1196668800"; 
   d="scan'208";a="243356304"
Message-ID: <4766C2D3.80702@linux.intel.com>
Date: Mon, 17 Dec 2007 10:41:23 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <4763F771.10105@s5r6.in-berlin.de> <47641B0F.3040709@linux.intel.com> <4766BF12.6050505@oracle.com>
In-Reply-To: <4766BF12.6050505@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
>>> Report counts may be too high due to duplicate recognition of the very
>>> same report.¹
>> this is true however it's .. a hard issue. It's really hard to
>> distinguish a duplicate report from
>> two reports of the same bug.
> 
> Can we hack some data in to oops output to help?  Say a giant per-boot
> anonymous random number (yeah, I know, harder than it sounds) and then
> an incrementing oops counter.

there already is a per-boot UUID afaik, just a matter of printing that..
I'll look into that, but it does add extra info to the oops print

>  That'd also let you discover that the
> latter oopses in a chain of oopses might be fall-out from the head of
> the chain.

this is there already and taken care of ;)
