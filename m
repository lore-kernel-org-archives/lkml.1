Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbZBYJQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbZBYJQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbZBYJQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:16:10 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:26301 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbZBYJQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Pl4E8wiIEa4rq1y4qemX8Z5knOD131wvOrcyhfL64LUbINbEGDoNC7sABrjYnqoQWe
         1Ygmn1x+nSmw+ar2qU8zyU4vA0p+zNz0J/rVjK1isU6mUVC2LAPDJcKVlc7AH6hi6x5X
         Mb5K2cbCWYTUfegjMUe0EoHhSZhy429sNuo/E=
Message-ID: <49A50C63.8040302@gmail.com>
Date: Wed, 25 Feb 2009 18:16:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysfs: Don't block indefinitely for unmapped files.
References: <m18wnvq6cr.fsf@fess.ebiederm.org>
In-Reply-To: <m18wnvq6cr.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> This patch modifies sysfs bin files so that we can remove
> the bin file while they are still mapped.  When the kobject
> is removed we unmap the bin file and arrange for future
> accesses to the mapping to receive SIGBUS.
> 
> Implementing this prevents a nasty DOS when pci devices are
> hot plugged and unplugged.  Where if any of their resources
> were mmaped the kernel could not free up their pci resources
> or release their pci data structures.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Heh... this is so cool.  I've never thought about it.  I would really
like more comments but other than that

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
