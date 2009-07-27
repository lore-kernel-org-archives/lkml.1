Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbZG0FPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbZG0FPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZG0FPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:15:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54102 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZG0FPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:15:51 -0400
Message-ID: <4A6D37A4.6020605@cn.fujitsu.com>
Date: Mon, 27 Jul 2009 13:14:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@google.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 3/6] Quick vmalloc vs kmalloc fix to the case where array
 size	is too large
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032150.2463.49019.stgit@hastromil.mtv.corp.google.com>
In-Reply-To: <20090724032150.2463.49019.stgit@hastromil.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Blum wrote:
> Quick vmalloc vs kmalloc fix to the case where array size is too large
> 
> Separates all pidlist allocation requests to a separate function that judges
> based on the requested size whether or not the array needs to be vmalloced or
> can be gotten via kmalloc, and similar for kfree/vfree. Should be replaced
> entirely with a kernel-wide solution to this general problem.
> 
> Depends on cgroup-pidlist-namespace.patch, cgroup-procs.patch
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> 

We'll either use flex_array or implement Paul's proposal, so I think
we can drop this patch?

