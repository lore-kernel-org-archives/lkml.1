Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbYB1BIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbYB1BIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbYB1BIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:08:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbYB1BIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:08:04 -0500
Message-ID: <47C60910.7000102@cn.fujitsu.com>
Date: Thu, 28 Feb 2008 09:06:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: fix return value of cpuset_populate()
References: <47C5131A.80508@cn.fujitsu.com>	 <20080227014135.0c361ab3.pj@sgi.com> <6599ad830802271649h29a13ceevf2255dd6235b42ba@mail.gmail.com>
In-Reply-To: <6599ad830802271649h29a13ceevf2255dd6235b42ba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Feb 26, 2008 at 11:41 PM, Paul Jackson <pj@sgi.com> wrote:
>>  - no need to check err == 0
>>  - the last return value of cgroup_add_file() is ignored
>>
>>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Looks fine from a cleanliness PoV, although since we don't actually do
> anything with an error result from subsys->populate() (a behaviour
> that I sort of inherited from cpusets ...) it won't make a whole lot
> of difference to the code.
> 
> A better change would be to make cpuset_populate() use cgroup_add_files().
> 

Yes, I'm considering this, and I will verify if this will save some bytes
in the object file.
