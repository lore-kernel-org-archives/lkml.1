Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbZKDXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbZKDXeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932752AbZKDXeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:34:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44816 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbZKDXeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:34:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan@smtp1.linux-foundation.org, Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       Safranek <jsafrane@redhat.com>
In-Reply-To: <20091104214030.GO5495@linux.vnet.ibm.com>
References: <6599ad830911041325i9b309a7y4d912d6be7ddbdd9@mail.gmail.com> <20091104214030.GO5495@linux.vnet.ibm.com>
Message-Id: <20091105082914.54D6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Nov 2009 08:34:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 04, 2009 at 01:25:46PM -0800, Paul Menage wrote:
> > On Wed, Nov 4, 2009 at 9:35 AM, Matt Helsley <matthltc@us.ibm.com> wrote:
> > >
> > > If anything, "standardizing" the mount point(s) will likely provide a false
> > > sense of uniformity and we'll get some bad userspace scripts/tools that
> > > break when "nonstandard" usage appears. Leaving the mount point undefined
> > > forces anyone writing scripts or tools to consider whether they want to be
> > > portable and, if so, the proper way to find the cgroup hierarchies they need
> > > to manipulate.
> > 
> > Scanning /proc/mounts to find the relevant mount locations is pretty
> > simple, for code that's just wanting to use existing cgroup mounts.
> > But for the code that sets up mounts in the first place, its probably
> > helpful to have recommendations of suitable locations.
> 
> libcgroup uses a configuration file specified by the user to do this.

You are right.
But fixed mount point help to make quick cute script for sys-admin.



