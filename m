Return-Path: <linux-kernel-owner+w=401wt.eu-S934512AbZJJPqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934512AbZJJPqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbZJJPqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:46:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:21841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbZJJPqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:46:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,538,1249282800"; 
   d="scan'208";a="558374309"
Message-ID: <4AD0ABFF.1020209@linux.intel.com>
Date: Sat, 10 Oct 2009 08:45:03 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Thomas Schlichter <thomas.schlichter@web.de>
CC: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
References: <200910100322.36857.thomas.schlichter@web.de> <4AD00C89.3000503@linux.intel.com> <200910101031.15620.thomas.schlichter@web.de>
In-Reply-To: <200910101031.15620.thomas.schlichter@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Schlichter wrote:

> Hmm, my CPU (VIA Nano) seems to support PAT, but Ubuntu disables this
> feature in its kernel config. I'm using 9.04, but even 9.10 will have PAT
> disabled:

that sounds like a bad idea. But to each distro their own I suppose.


> 
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-
> karmic.git;a=blob;f=debian.master/config/config.common.ubuntu;h=a43cbabd02bfdf5412de6fea232db86aa5d3e742;hb=HEAD

> So, convincing Ubuntu to enable PAT would be a workaround, but I think
> the problem would still exist and should be fixed.

I think it's time to get rid of CONFIG_PAT at all.. and just have it be there.
Making 10+ year old CPU features that are essential functionality a config option...
... not a good idea to be honest.
