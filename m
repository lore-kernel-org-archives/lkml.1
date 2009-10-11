Return-Path: <linux-kernel-owner+w=401wt.eu-S1751080AbZJKSzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080AbZJKSzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 14:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZJKSzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 14:55:53 -0400
Received: from mga05.intel.com ([192.55.52.89]:28360 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbZJKSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 14:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,542,1249282800"; 
   d="scan'208";a="735307594"
Message-ID: <4AD229FA.7020104@linux.intel.com>
Date: Sun, 11 Oct 2009 11:54:50 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Thomas Schlichter <thomas.schlichter@web.de>, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
References: <200910100322.36857.thomas.schlichter@web.de> <4AD00C89.3000503@linux.intel.com> <20091011185114.GB18578@khazad-dum.debian.net>
In-Reply-To: <20091011185114.GB18578@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Fri, 09 Oct 2009, Arjan van de Ven wrote:
>>> I've found a problem with X.org not setting up MTRR for the
>>> framebuffer memory. After I investigated I think this is not a
>>> X.org problem, but a kernel issue.
>> is there any CPU left that does not support PAT ?
> 
> A few million of them.  Like every Centrino laptop out there, unless the
> kernel blacklist for PAT on Intel CPUs is wrong.

afaik it is extremely conservative right now. FAR too much so.

