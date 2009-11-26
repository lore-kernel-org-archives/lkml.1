Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbZKZK0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbZKZK0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbZKZK0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:26:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZKZK0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:26:34 -0500
Subject: Re: [PATCH -tip 2/3] remove task_{u,s,g}time()
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <4B0E16D1.70902@jp.fujitsu.com>
References: <4B061E9A.8040100@jp.fujitsu.com>
	 <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>
	 <4B0B714C.9080607@jp.fujitsu.com> <4B0B8683.6020104@jp.fujitsu.com>
	 <4B0E16D1.70902@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 11:26:22 +0100
Message-ID: <1259231182.4273.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 14:49 +0900, Hidetoshi Seto wrote:
> Now all task_{u,s}time() pairs are replaced by task_times().
> And task_gtime() is too simple to be an inline function.
> 
> Cleanup them all.

Cleanups are always nice!
