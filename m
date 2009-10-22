Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZJVIpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZJVIpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZJVIpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:45:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZJVIps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:45:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=haZ4FZeRDkPSKBeagtcSQyIGLdlFQHxzrERHDWcAVEiIbU6xH2rEsnWubxjioV1F0
	QedAr6QsfIXlzmlwwfjyw==
Date: Thu, 22 Oct 2009 01:45:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Documentation: ABI: rename sysfs-devices-cache_disable
 properly
In-Reply-To: <20091022034515.13399.39630.stgit@bob.kio>
Message-ID: <alpine.DEB.2.00.0910220144130.9591@chino.kir.corp.google.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <20091022034515.13399.39630.stgit@bob.kio>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009, Alex Chiang wrote:

> Rename sysfs-devices-cache_disable to sysfs-devices-system-cpu, in
> order to keep a stricter correlation between a sysfs directory and
> its documentation.
> 
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Adding Mark Langsdorf <mark.langsdorf@amd.com> to the cc since this is his 
file and Ingo since he pushed it to Linus.

Acked-by: David Rientjes <rientjes@google.com>

> ---
> 
>  .../ABI/testing/sysfs-devices-cache_disable        |   18 ------------------
>  Documentation/ABI/testing/sysfs-devices-system-cpu |   18 ++++++++++++++++++
>  2 files changed, 18 insertions(+), 18 deletions(-)
>  delete mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-system-cpu
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-cache_disable
> deleted file mode 100644
> index 175bb4f..0000000
> --- a/Documentation/ABI/testing/sysfs-devices-cache_disable
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
> -Date:      August 2008
> -KernelVersion:	2.6.27
> -Contact:	mark.langsdorf@amd.com
> -Description:	These files exist in every cpu's cache index directories.
> -		There are currently 2 cache_disable_# files in each
> -		directory.  Reading from these files on a supported
> -		processor will return that cache disable index value
> -		for that processor and node.  Writing to one of these
> -		files will cause the specificed cache index to be disabled.
> -
> -		Currently, only AMD Family 10h Processors support cache index
> -		disable, and only for their L3 caches.  See the BIOS and
> -		Kernel Developer's Guide at
> -		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
> -		for formatting information and other details on the
> -		cache index disable.
> -Users:    joachim.deguara@amd.com
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> new file mode 100644
> index 0000000..175bb4f
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -0,0 +1,18 @@
> +What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
> +Date:      August 2008
> +KernelVersion:	2.6.27
> +Contact:	mark.langsdorf@amd.com
> +Description:	These files exist in every cpu's cache index directories.
> +		There are currently 2 cache_disable_# files in each
> +		directory.  Reading from these files on a supported
> +		processor will return that cache disable index value
> +		for that processor and node.  Writing to one of these
> +		files will cause the specificed cache index to be disabled.
> +
> +		Currently, only AMD Family 10h Processors support cache index
> +		disable, and only for their L3 caches.  See the BIOS and
> +		Kernel Developer's Guide at
> +		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
> +		for formatting information and other details on the
> +		cache index disable.
> +Users:    joachim.deguara@amd.com
> 
> 
