Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYDDOB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYDDOB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYDDOBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:01:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:17554 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYDDOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f3IMQtapxBirMxaVHLQ+iDidJrPa4ctF4qwbFbfbdsf0CFZq2+ODwoiDJoE44pQLreHmUw4DzntWyvRXyZrqreaM+lvbb0W2kWBJiXMw9+YrMoqbGtOumHtcAH9ehPmNSVPCQ9fEadFrASEsuOUtyLhckhEghdo15iTuhIRvs1I=
Message-ID: <2f11576a0804040701s5b6267b0w430c29b5010bf841@mail.gmail.com>
Date: Fri, 4 Apr 2008 23:01:45 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Make the memory controller more desktop responsive (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080404132116.5217.14401.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404132116.5217.14401.sendpatchset@localhost.localdomain>
X-Google-Sender-Auth: 5e410b63736c6d1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  @@ -612,7 +611,7 @@ retry:
>         pc->page = page;
>         pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
>         if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
>  -               pc->flags |= PAGE_CGROUP_FLAG_CACHE;
>  +               pc->flags = PAGE_CGROUP_FLAG_CACHE;
>
>         lock_page_cgroup(page);
>         if (page_get_page_cgroup(page)) {

Yes.
in general, cache page create as cold page.
if not, large file copy or streaming file drop all cache easily.

Reviewd-by: KOSAKI
