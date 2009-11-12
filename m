Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZKLR04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZKLR04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZKLR0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:26:55 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55795 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZKLR0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:26:55 -0500
Date: Thu, 12 Nov 2009 09:26:40 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Badari Pulavarty <pbadari@us.ibm.com>,
       David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 1/5] mm: add numa node symlink for memory section in
	sysfs
Message-ID: <20091112172640.GA9320@us.ibm.com>
References: <20091110223154.25636.48462.stgit@bob.kio> <20091110223644.25636.77587.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110223644.25636.77587.stgit@bob.kio>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 03:36:44PM -0700, Alex Chiang wrote:
> Commit c04fc586c (mm: show node to memory section relationship with
> symlinks in sysfs) created symlinks from nodes to memory sections, e.g.
> 
> /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> 
> If you're examining the memory section though and are wondering what
> node it might belong to, you can find it by grovelling around in
> sysfs, but it's a little cumbersome.
> 
> Add a reverse symlink for each memory section that points back to the
> node to which it belongs.

Hi Alex,
I'm kinda late to the party but I finally had a chance to review
and try it out on one of our systems today.  Looks good to me.
Tested-by: Gary Hade <garyhade@us.ibm.com>
Acked-by: Gary Hade <garyhade@us.ibm.com>

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

