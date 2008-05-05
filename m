Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYEEBVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYEEBVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 21:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYEEBVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 21:21:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:2536 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYEEBVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 21:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,435,1204531200"; 
   d="scan'208";a="324438307"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Date: Mon, 5 May 2008 09:21:18 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC01228AE5@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <481DAC94.4050506@qumranet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Thread-Index: Acit4sPKJYrYg58NR/uw/hUhoxptjQAavxRw
References: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk>	<42DFA526FC41B1429CE7279EF83C6BDC011CA51F@pdsmsx415.ccr.corp.intel.com>	<20080428141402.GD5882@ZenIV.linux.org.uk>	<20080428182416.GE5882@ZenIV.linux.org.uk> <42DFA526FC41B1429CE7279EF83C6BDC011CAECD@pdsmsx415.ccr.corp.intel.com> <481DAC94.4050506@qumranet.com>
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: "Avi Kivity" <avi@qumranet.com>
Cc: "Al Viro" <viro@ZenIV.linux.org.uk>, <sfr@canb.auug.org.au>,
       <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <kvm-ia64-devel@lists.sourceforge.net>,
       "Al Viro" <viro@ftp.linux.org.uk>
X-OriginalArrivalTime: 05 May 2008 01:21:19.0278 (UTC) FILETIME=[52603CE0:01C8AE4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Zhang, Xiantao wrote:
>> Hi, Airo
>>     Currenlty,  We only allow CONFIG_KVM_INTEL = m , since it needs
>> to be relocated at insertion time.
>> 
> 
> In many ways this module is more like firmware than a standard kernel
> module, no?

Right, this module doesn't work in kernel context. Instead, it is
responsible for switching world between host and guest after relocation.
In this way, likely to be a firmware. 
Xiantao
