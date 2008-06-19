Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYFSGJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYFSGJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYFSGJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:09:20 -0400
Received: from mga10.intel.com ([192.55.52.92]:64416 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752764AbYFSGJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,671,1204531200"; 
   d="scan'208";a="343199801"
Message-ID: <4859F7FF.2010406@linux.intel.com>
Date: Wed, 18 Jun 2008 23:09:03 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Or could this perhaps be an indication that it is specific to i686 some 
> way (eg a compiler issue?)
> 

Dave Airlie just confirmed this is a compiler bug indeed in gcc 4.3.1
and pointed at https://bugzilla.redhat.com/show_bug.cgi?id=451068

