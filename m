Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXIXSQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXIXSQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXIXSQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:16:32 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34169 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbXIXSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:16:31 -0400
Message-ID: <46F7FEF9.2070702@davidnewall.com>
Date: Tue, 25 Sep 2007 03:46:25 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       tytso@thunk.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: bug in fsck or ext2/ext3?
References: <46F7EC47.9010803@nagafix.co.uk> <20070924170439.GF8127@redhat.com>
In-Reply-To: <20070924170439.GF8127@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, Sep 24, 2007 at 05:56:39PM +0100, Antoine Martin wrote:
>
>  > # rm -fr tmp/chroot.broken
>  > rm: cannot remove directory (...)
>  > Same result when trying to do anything to those files chown/chmod/touch:
>  > "Operation not permitted"
>
> Various files in the directories it complains about have their 'i'
> bit set.  lsattr will show you.   chattr -i those files, and the
> directory is removable again.

Additionally, this is a classic symptom of malware.  A directory  named 
"..." is a big hint.
