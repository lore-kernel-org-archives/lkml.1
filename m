Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYBZDZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYBZDZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbYBZDZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:25:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63175 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbYBZDZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:25:05 -0500
Message-ID: <47C3862D.8080603@cn.fujitsu.com>
Date: Tue, 26 Feb 2008 11:23:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] CGroup API files: Various cleanup to CGroup control
 files
References: <20080223224725.115590000@menage.corp.google.com>
In-Reply-To: <20080223224725.115590000@menage.corp.google.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> This patchset is a roll-up of the non-contraversial items of the
> various patches that I've sent out recently, fixed according to the
> feedback received.
> 
> In summary they are:
> 
> - general rename of read_uint/write_uint to read_u64/write_u64
> 
> - use these methods for cpusets and memory controller files
> 
> - add a read_map cgroup file method, and use it in the memory
>   controller
> 
> - move the "releasable" control file to the debug subsystem
> 
> - make the debug subsystem config option default to "n"
> 
> The only user-visible changes are the movement of the "releasable"
> file and the fact that some write_u64()-based control files are now
> more forgiving of additional whitespace at the end of their input.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> --
> --

Should those pathces be rebased againt 2.6.25-rc3 ?
