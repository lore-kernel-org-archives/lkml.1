Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195Ab0AMJI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0AMJI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009Ab0AMJI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:08:58 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59393 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0AMJI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n8rK8Mfrdfim34ItKFVoCSz44mchAHOTfS9EA5P2TwRhesMTMByDA7jPvc5y6uA9+G
         YK2g4E5wioDXSC3g9VDxuGegkSpvk2P8QoaqhkMIiIpMoQOFx5zgwfSWP3F5fMmwfK9l
         h6kDVP3/sBXZDaHmoMRfvImWrDOMYd/3Ix8S4=
MIME-Version: 1.0
In-Reply-To: <20100113172143.B3E8.A69D9226@jp.fujitsu.com>
References: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
	 <20100113172143.B3E8.A69D9226@jp.fujitsu.com>
Date: Wed, 13 Jan 2010 14:38:52 +0530
X-Google-Sender-Auth: f1c79dd16449af12
Message-ID: <661de9471001130108w2891dc5es16ec3bbca56fa9f0@mail.gmail.com>
Subject: Re: [PATCH 3/3] [v2] memcg: add anon_scan_ratio to memory.stat file
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 1:52 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Changelog
>  since v1: cancel to remove "recent_xxx" debug statistics as bilbir's
>  mention
>
> ===========================================
>
> anon_scan_ratio feature doesn't only useful for global VM pressure
> analysis, but it also useful for memcg memroy pressure analysis.
>
> Then, this patch add anon_scan_ratio field to memory.stat file too.
>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

[snip]

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
