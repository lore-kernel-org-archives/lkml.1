Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZCDCHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZCDCHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZCDCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:06:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58097 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZCDCGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:06:52 -0500
Date: Wed, 4 Mar 2009 11:05:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroups: show correct file mode, fix
Message-Id: <20090304110531.abef38dc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49ADE099.1090009@cn.fujitsu.com>
References: <49ACC037.2090507@cn.fujitsu.com>
	<20090303122733.af5ceea9.akpm@linux-foundation.org>
	<49ADDEF9.7020308@cn.fujitsu.com>
	<20090304105403.23352011.kamezawa.hiroyu@jp.fujitsu.com>
	<49ADE099.1090009@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Mar 2009 09:59:53 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 04 Mar 2009 09:52:57 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> - 'mode' should have type mode_t
> >> - use S_IRUGO/S_IWUSR instead of 0444/0200
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Thank you for quick work. I'll write memcg part on this.
> > 
> 
> Ah, you don't need to do so. All the files in memcg will show their
> correct file mode, which is what this patch does.
> 
I see.

Thanks,
-Kame 

