Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbXLQSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbXLQSZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXLQSZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:25:39 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:59361 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbXLQSZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:25:38 -0500
Message-ID: <4766BF12.6050505@oracle.com>
Date: Mon, 17 Dec 2007 10:25:22 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <4763F771.10105@s5r6.in-berlin.de> <47641B0F.3040709@linux.intel.com>
In-Reply-To: <47641B0F.3040709@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Report counts may be too high due to duplicate recognition of the very
>> same report.¹
> 
> this is true however it's .. a hard issue. It's really hard to
> distinguish a duplicate report from
> two reports of the same bug.

Can we hack some data in to oops output to help?  Say a giant per-boot
anonymous random number (yeah, I know, harder than it sounds) and then
an incrementing oops counter.  That'd also let you discover that the
latter oopses in a chain of oopses might be fall-out from the head of
the chain.

- z
