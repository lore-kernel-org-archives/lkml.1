Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYDWLBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYDWLBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYDWLBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:01:40 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59458 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYDWLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:01:39 -0400
X-AuditID: 0ac90650-aaaebba000000cfa-b8-480f1711599f
Message-ID: <480F1704.5080607@hitachi.com>
Date: Wed, 23 Apr 2008 20:01:24 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: cmm@us.ibm.com
Cc: Josef Bacik <jbacik@redhat.com>, akpm@linux-foundation.org, sct@redhat.com,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
References: <48089B86.5020108@hitachi.com> 
    <20080418140946.GA26062@unused.rdu.redhat.com> 
    <1208546807.9475.4.camel@localhost.localdomain>
In-Reply-To: <1208546807.9475.4.camel@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mingming Cao wrote:

>>>This patch set fixes several error handling problems to protect
>>>from filesystem corruption caused by I/O errors.  It has been
>>>done only for JBD and ext3 parts.
> 
> Could you sent Ext4/JBD2 version patches? Thanks!

I will try it, but I don't know I can send the Ext4/JBD2 version
within a reasonable time because I haven't read Ext4/JBD2 codes
so much yet.
 
>>There doesn't seem like much point in taking these patches as Jan is rewriting
>>the ordered mode path and most of these functions will be going away soon.
>>Those patches seem like they will be coming soon and will obsolete these.
> 
> I hope we have a better ordered mode very soon too. Just thought it's
> still valid to fix the current ordered mode for people who uses
> linux-2.6.25 kernel today. 

And older kernel users will be happy if someone or I make a backport
of this patch set.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

