Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXHQCo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXHQCo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXHQCot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:44:49 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39028 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754989AbXHQCos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:44:48 -0400
Message-ID: <387318684.03065@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 17 Aug 2007 10:44:44 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, John Berthels <jjberthels@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] maps: PSS(proportional set size) accounting in
	smaps
Message-ID: <20070817024443.GA5521@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.064901548@mail.ustc.edu.cn> <20070817021346.GH30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817021346.GH30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:13:47PM -0500, Matt Mackall wrote:
> On Fri, Aug 17, 2007 at 06:05:17AM +0800, Fengguang Wu wrote:
> > The "proportional set size" (PSS) of a process is the count of pages it has in
> > memory, where each page is divided by the number of processes sharing it. So if
> > a process has 1000 pages all to itself, and 1000 shared with one other process,
> > its PSS will be 1500.
> >                - lwn.net: "ELC: How much memory are applications really using?"
> > 
> > The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
> > memory footprint. So collect and export it via /proc/<pid>/smaps.
> > 
> > Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job.
> > They are comprehensive tools. But for PSS, let's do it in the simple way. 
> 
> It's a bit odd that you attribute the description of PSS to LWN rather
> than me. But anyway:
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Sorry and thank you!
I'll change it in the next take.

