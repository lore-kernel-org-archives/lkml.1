Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab0BLCjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 21:39:39 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:48227 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab0BLCji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 21:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=P37SECwqemcF6xgMJw5ghsrocBgmXwM+0hJSx3k0qSvOl8hw6nVIoFSnJSIH+uzeTT
         ijfYMu9vPiZ/uSqkfsvOeMPrURbrX/A5EI+MtQgGefPKq4ZMnAPJTsNesB6XCnFyeykg
         +njDAPvvKChioyyt6KOguYNvlSuxF0lEMtkew=
MIME-Version: 1.0
In-Reply-To: <20100212105318.caf37133.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100212105318.caf37133.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 12 Feb 2010 11:39:35 +0900
Message-ID: <28c262361002111839t291b8ac2xdb9b89b354a115e0@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] memcg: fix oom killing a child process in an 
	other cgroup
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, stable@kernel.org,
       rientjes@google.com,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 10:53 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This patch itself is againt mmotm-Feb10 but can be applied to 2.6.32.8
> without problem.
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Now, oom-killer is memcg aware and it finds the worst process from
> processes under memcg(s) in oom. Then, it kills victim's child at first.
> It may kill a child in other cgroup and may not be any help for recovery.
> And it will break the assumption users have...
>
> This patch fixes it.
>
> CC: stable@kernel.org
> CC: Minchan Kim <minchan.kim@gmail.com>
> CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Sorry for noise, Kame.

-- 
Kind regards,
Minchan Kim
