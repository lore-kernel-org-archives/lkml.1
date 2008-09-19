Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYISP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYISP2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYISP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:28:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:1724 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYISP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qRITlXbtipHO1sUiO+NmGNoDXn5tjzYkGe14UXJy7JLnCYBlutgaO6H2lDkHh2/Anf
         0D5MuxjhkjlPU42gFGf2nkA8qwcu54KvwlXkwcV3E/93Zkpa+/ZG581IdAkKkVHs7q7u
         jtDNzPNHndGCPjQQXzfT0OI4+7lZAEOrLY1FU=
Message-ID: <2f11576a0809190828s4b74ac5y8cd6dd201332fbe2@mail.gmail.com>
Date: Sat, 20 Sep 2008 00:28:02 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [patch 0/4] Cpu alloc V5: Replace percpu allocator in modules.c
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
In-Reply-To: <20080919145859.062069850@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919145859.062069850@quilx.com>
X-Google-Sender-Auth: aaa8f9b8bb0d5dee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristoph,

> Just do the bare mininum to establish a per cpu allocator. Later patchsets
> will gradually build out the functionality.
>
> The most critical issue that came up on the last round is how to configure
> the size of the percpu area. Here we simply use a kernel parameter and use
> the static size of the existing percpu allocator for modules as a default.
>
> The effect of this patchset is to make the size of percpu data for modules
> configurable. Its no longer fixed at 8000 bytes.

I don't know so much this area.
Could you please what are the problem that you think　about?

performance?
fixed-size cause per-cpu starvation by huge user?
