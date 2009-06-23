Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZFWAhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZFWAhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFWAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:36:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZFWAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:36:52 -0400
Date: Mon, 22 Jun 2009 17:36:46 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: David Howells <dhowells@redhat.com>
cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
In-Reply-To: <6950.1245661098@redhat.com>
Message-ID: <alpine.DEB.2.01.0906221732120.6439@bogon>
References: <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/dM5s23PvwYBm4py5Ow2ZuStFrjg6+Wjf/7+0
 MDc7Vx6QEojQFF256FUgfCxAry4Y88+0tM23/g0sTIfqY8C8Vk
 GiYkkuTuLXNn8rzfwp5hA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, David Howells wrote:
>> [  399.332346]  [<ffffffff810da03a>] ? ext3_truncate+0x26a/0x9e0
> 
> Can you try the attached patch, please?

The patch helps, I think. Without this patch I was able to reproduce 
this very quickly, just running "grep -lr foo /share/nfs" was enough to
trigger the backtrace. With this patch, grep is still running (and 
utilizing cachefiles) but no warnings so far.

Thanks!
Christian.
-- 
BOFH excuse #83:

Support staff hung over, send aspirin and come back LATER.
