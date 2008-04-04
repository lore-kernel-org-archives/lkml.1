Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYDDODH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYDDODH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYDDOCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:02:55 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:62445 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYDDOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KxjW/n0xRrVjQXIRJI+iQ6HCmAZC/iYEAEpuGtOorCWWBb10WYsM8kvf+kme9NxGz7OcrG5Oijnb8th44mz7AmIea/kNk1dxAhzhsqogqqTkprBv5lDwQXcbCV4/UMZQ/F7p8UvcSnYKrBMZIzy2sBR4C7p9iRegCvR24fs1FOs=
Message-ID: <2f11576a0804040702j854653ble14fe655d25b922f@mail.gmail.com>
Date: Fri, 4 Apr 2008 23:02:51 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Make the memory controller more desktop responsive (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2f11576a0804040701s5b6267b0w430c29b5010bf841@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404132116.5217.14401.sendpatchset@localhost.localdomain>
	 <2f11576a0804040701s5b6267b0w430c29b5010bf841@mail.gmail.com>
X-Google-Sender-Auth: c169f0af47217f4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 11:01 PM, KOSAKI Motohiro
<m-kosaki@ceres.dti.ne.jp> wrote:
> Hi
>
>
>  >  @@ -612,7 +611,7 @@ retry:
>  >         pc->page = page;
>  >         pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
>  >         if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
>  >  -               pc->flags |= PAGE_CGROUP_FLAG_CACHE;
>  >  +               pc->flags = PAGE_CGROUP_FLAG_CACHE;
>  >
>  >         lock_page_cgroup(page);
>  >         if (page_get_page_cgroup(page)) {
>
>  Yes.
>  in general, cache page create as cold page.
>  if not, large file copy or streaming file drop all cache easily.
>
>  Reviewd-by: KOSAKI

sorry, I sent premature document.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
