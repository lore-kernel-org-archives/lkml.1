Return-Path: <linux-kernel-owner+w=401wt.eu-S934476AbYEBLk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbYEBLk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbYEBLkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:40:16 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:41564 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762448AbYEBLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:40:14 -0400
Date: Fri, 2 May 2008 13:39:23 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix flags length in net 9p
Message-ID: <20080502113923.GA7997@nibiru.local>
Reply-To: weigelt@metux.de
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> Some files in the net/9p directory uses "int" for flags. This can
> cause hard to find bugs on some architectures. This patch converts the
> flags to use "long" instead.

IMHO it would be more consequent and clean to introduce an separate 
type for this and only use specific macros for manipulation. Of course
this introduced some typing overhead, but enforces the coder to think
more carefully about his code. For critical things like kernel stuff,
I really prefer this way.


BTW: I just wondered a bit how the 9p driver finds out the numeric
user ID's for 9P user names.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
