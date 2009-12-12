Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbZLLNNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbZLLNNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 08:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbZLLNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 08:13:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:16521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759585AbZLLNNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 08:13:46 -0500
MIME-Version: 1.0
In-Reply-To: <cc557aab0912120511r7c83e97di3f97d2bb5eae326c@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	 <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	 <747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	 <9e6e8d687224c6cbc54281f7c3d07983f701f93d.1260571675.git.kirill@shutemov.name>
	 <20091212121902.e95f9561.d-nishimura@mtf.biglobe.ne.jp>
	 <cc557aab0912120511r7c83e97di3f97d2bb5eae326c@mail.gmail.com>
Date: Sat, 12 Dec 2009 15:13:52 +0200
Message-ID: <cc557aab0912120513q6e9cd518y1af2c6fbbd407b85@mail.gmail.com>
Subject: Re: [PATCH RFC v2 4/4] memcg: implement memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: nishimura@mxp.nes.nec.co.jp
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 3:11 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> Ok, I'll move it. It will affect performance of
> mem_cgroup_invalidate_thresholds(),
> but I don't think that it's important.

s/mem_cgroup_invalidate_thresholds()/mem_cgroup_register_event() and
mem_cgroup_unregister_event()/
