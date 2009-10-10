Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbZJJEZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbZJJEZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZJJEZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:25:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:38148 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbZJJEZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,535,1249282800"; 
   d="scan'208";a="734960035"
Message-ID: <4AD00C89.3000503@linux.intel.com>
Date: Fri, 09 Oct 2009 21:24:41 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Thomas Schlichter <thomas.schlichter@web.de>
CC: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
References: <200910100322.36857.thomas.schlichter@web.de>
In-Reply-To: <200910100322.36857.thomas.schlichter@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Schlichter wrote:
> Hi,
> 
> I've found a problem with X.org not setting up MTRR for the framebuffer 
> memory. After I investigated I think this is not a X.org problem, but a kernel 
> issue.

is there any CPU left that does not support PAT ?

eg in other words, should we try instead to get PAT working for you?
