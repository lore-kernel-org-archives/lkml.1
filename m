Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYITXQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYITXQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYITXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:16:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYITXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:16:44 -0400
Message-ID: <48D58401.4070403@linux-foundation.org>
Date: Sat, 20 Sep 2008 18:15:13 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 1/4] Make the per cpu reserve configurable
References: <20080919145859.062069850@quilx.com>	<20080919145928.322062135@quilx.com> <20080920125546.d6d7b42e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080920125546.d6d7b42e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Is this PERCPU_MODULE_RESERVE default size is fixex to 8192 bytes
> both on 32bit-arch and 64bit-arch ?
>   
Yes.
> How about enlarging this to twice on 64bit arch now ?
>
> sorry for noise.
No actually a good idea to discuss the limit here. Maybe use 10000 for 32 bit and 15000 for 64 bit? Many percpu variables are counters that may be integers.



