Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZBLGPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZBLGPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZBLGPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:15:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55928 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZBLGPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:15:08 -0500
Message-ID: <4993BE57.9000705@cn.fujitsu.com>
Date: Thu, 12 Feb 2009 14:14:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com> <20090209112321.GW28946@ZenIV.linux.org.uk> <1234180131.5951.85.camel@laptop> <4990EF3F.3010501@cn.fujitsu.com> <20090210043733.GY28946@ZenIV.linux.org.uk> <49910E55.7050905@cn.fujitsu.com> <20090210060737.GZ28946@ZenIV.linux.org.uk> <49914815.4020209@cn.fujitsu.com>
In-Reply-To: <49914815.4020209@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> BTW, which dentries are going to stick around until that point?
>>
> 
> Not sure if I got what you mean. cgroup_kill_sb() will be called only if there
> are no sub-dirs.
> 

Though at this point there won't be any sub-dirs, we have dentries of all the
control files (normal file) in the root dir.

