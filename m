Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYDWLAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYDWLAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYDWK7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:59:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58865 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYDWK7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:59:54 -0400
X-AuditID: 0ac90646-aa2efba0000012f4-ea-480f16a713d4
Message-ID: <480F169F.4060104@hitachi.com>
Date: Wed, 23 Apr 2008 19:59:43 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Josef Bacik <jbacik@redhat.com>
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
References: <48089B86.5020108@hitachi.com> 
    <20080418140946.GA26062@unused.rdu.redhat.com>
In-Reply-To: <20080418140946.GA26062@unused.rdu.redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik wrote:

> On Fri, Apr 18, 2008 at 10:00:54PM +0900, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
>>
>>This patch set fixes several error handling problems to protect
>>from filesystem corruption caused by I/O errors.  It has been
>>done only for JBD and ext3 parts.
>>
> There doesn't seem like much point in taking these patches as Jan is rewriting
> the ordered mode path and most of these functions will be going away soon.
> Those patches seem like they will be coming soon and will obsolete these.

Yes, PATCH 1/4 and PATCH 2/4 are specific to the ordered mode, and Jan's
patches seem to fix the same problems.  But the remain patches target
generic journaling problems, so I think those patches are still needed.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


