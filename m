Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXHRKb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXHRKb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXHRKbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:31:50 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:35479 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752699AbXHRKbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:31:49 -0400
Message-ID: <387433106.08432@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 18 Aug 2007 18:31:46 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in
	granularity of pages
Message-ID: <20070818103146.GA6744@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn> <20070817165808.GM30556@waste.org> <20070818024831.GA7856@mail.ustc.edu.cn> <20070818064042.GQ30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818064042.GQ30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 01:40:42AM -0500, Matt Mackall wrote:
> > > - you don't get page frame numbers
> > 
> > True. I guess PFNs are meaningless to a normal user?
> 
> They're useful for anyone who's trying to look at the system as a
> whole.

To answer the question: "who are sharing this page with me"?
PFNs are not the only option. The tuple dev/ino/offset can also
uniquely identify the shared page :)

