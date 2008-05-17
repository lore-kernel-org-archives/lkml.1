Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYEQJte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYEQJte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 05:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYEQJtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 05:49:25 -0400
Received: from main.gmane.org ([80.91.229.2]:59098 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYEQJtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 05:49:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s
 laptop
Date: Sat, 17 May 2008 09:49:07 +0000 (UTC)
Message-ID: <g0m9mj$l41$1@ger.gmane.org>
References: <E1JxGth-0001te-S4@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 03:32:05 -0400, Theodore Ts'o wrote:

> The X server failed to come up using the Intel driver, and forced a
> fallback to the 800x600 VESA server.  This was on my Lenovo X61s laptop
>
> The git bisect identified this commit as the guilty one:
> 
> 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b is first bad commit commit
> 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b Author: Venki Pallipadi
> <venkatesh.pallipadi@intel.com> Date:   Wed May 14 16:05:51 2008 -0700
> 
>     mprotect: prevent alteration of the PAT bits

This sounds related to
http://groups.google.com/group/linux.kernel/browse_frm/thread/1dba81049ce4ad16/546aff3e91055ab7#546aff3e91055ab7 ...

-- 
Sitsofe | http://sucs.org/~sits/

