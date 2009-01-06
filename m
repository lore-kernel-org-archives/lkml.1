Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbZAFSvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbZAFSvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZAFSvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:51:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZAFSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:51:43 -0500
Message-ID: <4963A859.6030406@zytor.com>
Date: Tue, 06 Jan 2009 10:52:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alexey Fisher <bug-track@fisher-privat.net>
CC: kernel-testers-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [regression] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
References: <4963A71C.2020107@fisher-privat.net>
In-Reply-To: <4963A71C.2020107@fisher-privat.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher wrote:
> glx perfomance regression after this patch.
> goot kernel: glxgears = 1400 fps
> bad kernel: glxgears = 300 fps ( same speed with disabled drm module )
> 
> kernel log:
> glxgears:5775 map pfn expected mapping type write-back for
> d1000000-d1c80000, got uncached-minus
> glxgears:5775 freeing invalid memtype d1000000-d1c80000
> 

Have we caught a case of actual overlap, i.e. a driver bug here?

	-hpa
