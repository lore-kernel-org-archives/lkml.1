Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZGNAbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZGNAbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZGNAbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:31:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60027 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZGNAbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:31:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH 0/2] Memory usage limit notification feature (v3)
Cc: kosaki.motohiro@jp.fujitsu.com, Vladislav Buzov <vbuzov@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Linux memory management list <linux-mm@kvack.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <6599ad830907131720j4f7e1649y4866d2ddeae862c5@mail.gmail.com>
References: <1247530581-31416-1-git-send-email-vbuzov@embeddedalley.com> <6599ad830907131720j4f7e1649y4866d2ddeae862c5@mail.gmail.com>
Message-Id: <20090714093023.6280.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Jul 2009 09:31:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jul 13, 2009 at 5:16 PM, Vladislav
> Buzov<vbuzov@embeddedalley.com> wrote:
> >
> > The following sequence of patches introduce memory usage limit notification
> > capability to the Memory Controller cgroup.
> >
> > This is v3 of the implementation. The major difference between previous
> > version is it is based on the the Resource Counter extension to notify the
> > Resource Controller when the resource usage achieves or exceeds a configurable
> > threshold.
> >
> > TODOs:
> >
> > 1. Another, more generic notification mechanism supporting different  events
> >   is preferred to use, rather than creating a dedicated file in the Memory
> >   Controller cgroup.
> 
> I think that defining the the more generic userspace-API portion of
> this TODO should come *prior* to the new feature in this patch, even
> if the kernel implementation isn't initially generic.

I fully agree this ;-)



