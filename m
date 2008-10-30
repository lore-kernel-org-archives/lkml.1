Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbYJ3XDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbYJ3XDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYJ3XDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:03:15 -0400
Received: from mail.tpi.com ([198.107.51.143]:2366 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679AbYJ3XDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:03:13 -0400
Message-ID: <490A3D2B.2060400@canonical.com>
Date: Thu, 30 Oct 2008 17:03:07 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Tomas Winkler <tomasw@gmail.com>,
       reinette chatre <reinette.chatre@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [MEMO] ftrace suckage++
References: <43e72e890810301445r665a0139g752fb1c97069fe59@mail.gmail.com>
In-Reply-To: <43e72e890810301445r665a0139g752fb1c97069fe59@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> As johannes pointed out to me the culprit to the e1000e corruption was
> determined to be ftrace related [1]. Well it seems I hit an oops with
> ftrace using iwlagn after a simple load of the module using
> wireless-testing. I'm not sure if john's tree yet has ftrace fixes.
> Both Fedora 10 and Ubuntu 8.10 had dynamic ftrace enabled so users on
> these first kernels and using compat-wireless may run into this so
> just putting this out there. I'll can check for this flag in
> compat-wireless for now and bitch/exit if its enabled unless someone
> has a better idea.
> 
> [1] http://lwn.net/Articles/303390/
> 

I disabled it in the 2.6.27 Intrepid Ubuntu kernel prior to release.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
