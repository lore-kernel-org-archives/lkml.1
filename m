Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZKHNm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZKHNm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZKHNm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:42:28 -0500
Received: from ey-out-1920.google.com ([74.125.78.146]:28852 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZKHNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:42:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MgXWgH9U9deQCWpuupy6HimOxv1y95N/a4rY2QVQ+Ee3pzOSmWx+gyD5IQH6Rz7upb
         MLH8X7Kv67TJ7CA8TkOoX2ySWIqfk30fRcIOfKrWZNqWxT0iIEBBH+ZxeYOLdZHwS2Lh
         4YsVWOC4dcYOgqoH0IuWfKCADIJ0Bd1oNW8Kg=
Date: Sun, 8 Nov 2009 16:42:30 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yong Wang <yong.y.wang@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, therm: Only read the initial value of thermal LVT
	entry on BSP
Message-ID: <20091108134230.GE5300@lenovo>
References: <20091107001736.GA30790@ywang-moblin2.bj.intel.com> <1257562565.4083.485.camel@sbs-t61.sc.intel.com> <20091108102520.GC7233@elte.hu> <20091108123812.GA877@ywang-moblin2.bj.intel.com> <20091108131655.GA12837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108131655.GA12837@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 08, 2009 at 02:16:55PM +0100]
| 
...
|
| > > that makes it cleaner, and also it will work if we dont boot on 
| > > cpu==0. (should that ever occur)
| > > 
| > 
| > May I know when will this happen?
| 
| It's not really expected - we factorize the CPU IDs (which are logical) 
| so that the boot CPU is 0. But relying on cpu==0 is the boot cpu is not 
| clean and the resulting code is harder to read.

Perhaps we need some is_bsp_cpu() helper? Though to cover all x86 places
we need some efforts to apply :/

| 
| 	Ingo
| 
	-- Cyrill
