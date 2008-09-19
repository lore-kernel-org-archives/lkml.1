Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYISPvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYISPvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYISPvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:51:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbYISPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:51:24 -0400
Message-ID: <48D3CA40.3090807@linux-foundation.org>
Date: Fri, 19 Sep 2008 10:50:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/4] Cpu alloc V5: Replace percpu allocator in modules.c
References: <20080919145859.062069850@quilx.com> <2f11576a0809190828s4b74ac5y8cd6dd201332fbe2@mail.gmail.com>
In-Reply-To: <2f11576a0809190828s4b74ac5y8cd6dd201332fbe2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> 
> I don't know so much this area.
> Could you please what are the problem that you think　about?

F.e. Someone is loading lots of modules with lots of percpu data. This will
currently fail if there are more than 8000 bytes allocated. With the percpu
option the size can be configured on bootup. A minor thing but the allocator
can later be used for other things. See the full cpu alloc patchsets that have
been posted before (last one in May).

