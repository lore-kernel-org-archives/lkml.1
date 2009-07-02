Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZGBDTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZGBDTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 23:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZGBDTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 23:19:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53262 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZGBDTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 23:19:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 12:17:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 8/9] [RFC] Example multi-bindable subsystem: a
 per-cgroup  notes field
Message-Id: <20090702121728.2a7c93cd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830907011956i33769d5ek5401e93553d75c59@mail.gmail.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	<20090702021133.14469.35140.stgit@menage.mtv.corp.google.com>
	<20090702114829.df04c885.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830907011956i33769d5ek5401e93553d75c59@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 19:56:28 -0700
Paul Menage <menage@google.com> wrote:

> On Wed, Jul 1, 2009 at 7:48 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Hmm, do we need to this "info" file as subsys ? How about making this as
> > default file set ? (if there are users.)
> >
> 
> That would certainly be possible, and would be an alternative to
> having multi-bindable subsystem support.
> 
> The advantage of adding multi-bindable subsystems is that you can
> avoid bloating the core cgroups code, by putting individual small
> cgroups features in their own code modules, and you get to decide at
> mount time which features are actually mounted; if they were part of
> the core cgroups files, then there would either need to be special
> mount options for each separate feature, or else no way to pick which
> features were mounted on each hierarchy.
> 
Sure, thanks.

-Kame

> Paul
> 

