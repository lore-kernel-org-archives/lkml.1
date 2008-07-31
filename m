Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYGaHMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYGaHMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYGaHL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:11:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56490 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYGaHL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:11:58 -0400
Message-ID: <48916557.8070508@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 15:10:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
References: <48912FDD.8060006@cn.fujitsu.com>
In-Reply-To: <48912FDD.8060006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> ntasks is not a monotonic increasing value,
> So maybe fudge+1 processes are created when kmalloc and killed
> when kfree in every loop. And the loop will not end or
> repetition a long time.
> 
> This patch prevent this kind of attack.
> 

Could you demonstrate how to manage to do this so-called attack in
real-life?

