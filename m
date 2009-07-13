Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbZGMXvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbZGMXvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbZGMXvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:51:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58056 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZGMXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:51:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Jul 2009 08:49:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Benjamin Blum <bblum@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where
 array  size is too large
Message-Id: <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	<20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	<4A5AA3E7.9070800@cn.fujitsu.com>
	<20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	<2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 11:27:43 -0400
Benjamin Blum <bblum@google.com> wrote:

> On Mon, Jul 13, 2009 at 2:03 AM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > ???? why not using vmalloc() always ?
> >
> > Thanks,
> > -Kame
> >
> 
> The idea behind this patch is that in most cases, we want to use
> kmalloc for performance, but sometimes the array will be too big. See
> the previous thread (linked in the root message of this thread) for
> discussion of the issue.
> 
IIUC, this place, .../procs interface is not so important for performance
as to being allowed this ugly conding.

Thanks,
-Kame

