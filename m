Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZJZR34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZJZR34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZJZR3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:29:55 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52876 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZJZR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:29:54 -0400
Message-ID: <4AE5DC80.8010204@oracle.com>
Date: Mon, 26 Oct 2009 10:29:36 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP_EXTENT_SHARED
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com> <1256173509-2831-2-git-send-email-sunil.mushran@oracle.com> <20091023180034.GA11402@wotan.suse.de> <20091024183039.GB30762@shareable.org>
In-Reply-To: <20091024183039.GB30762@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AE5DC88.021D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> It might be better to have a flag FIEMAP_EXTENT_NOT_SHARED.
>
> Apps which need to know the data is not shared can't safely check
> !(flags & FIEMAP_EXTENT_SHARED) because of old kernels which don't set
> the flag.

I'm probably not understanding your point. Won't the older kernels not set
FIEMAP_EXTENT_NOT_SHARED too.

If this is important, we could always add this flag in the stable kernel
trees. Both sharing of extents and fiemap are relatively new to the kernel.

