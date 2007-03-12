Return-Path: <linux-kernel-owner+w=401wt.eu-S965860AbXCLNwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbXCLNwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965870AbXCLNwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:52:36 -0400
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:2686 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965860AbXCLNw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:52:29 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Date: Mon, 12 Mar 2007 13:52:19 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070312085447.GA10955@janus> <200703121207.19042.s0348365@sms.ed.ac.uk> <20070312132546.GC12265@janus>
In-Reply-To: <20070312132546.GC12265@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121352.19505.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 13:25, Frank van Maarseveen wrote:
[snip]
> So, are /dev/hd* going to disappear in a few years? iow, does it make
> sense to _slowly_ start to migrate to /dev/sd*?

How would you propose doing this? I'm sure modern distros with an 
initrd/initramfs probably already do some sort of root detection. Doesn't fix 
the fstab issue, but I suppose this could be auto-generated too.

> The problem is there's no plan B in case of any troubles except rename
> everything back again to boot an old kernel.

I doubt this matters for distributors, as they'll simply switch over when you 
upgrade the distro, and the earliest supported kernel will be the one that 
shipped with the newer version.

I accept that it's a bit of a drag, but it's better to have a standard naming 
convention for all disks, isn't it?

Glad this is working for you.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
