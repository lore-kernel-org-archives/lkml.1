Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZJMAcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZJMAcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZJMAcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:32:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52032 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZJMAcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:32:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Oct 2009 09:29:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 0/2] memcg: improving scalability by reducing lock 
 contention at charge/uncharge
Message-Id: <20091013092920.7d509ffa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <604427e00910111134o6f22f0ddg2b87124dd334ec02@mail.gmail.com>
References: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
	<604427e00910091737s52e11ce9p256c95d533dc2837@mail.gmail.com>
	<f82dee90d0ab51d5bd33a6c01a9feb17.squirrel@webmail-b.css.fujitsu.com>
	<604427e00910111134o6f22f0ddg2b87124dd334ec02@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 11:34:39 -0700
Ying Han <yinghan@google.com> wrote:

> 2009/10/10 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> > This patch series is only for "child" cgroup. Sorry, I had to write it
> > clearer. No effects to root.
> >
> 
> Ok, Thanks for making it clearer. :) So Do you mind post the cgroup+memcg
> configuration
> while you are running on your host?
> 

#mount -t cgroup /dev/null /cgroups -omemory
#mkdir /cgroups/A
#echo $$ > /cgroups/A

and run test.

Thanks,
-Kame


