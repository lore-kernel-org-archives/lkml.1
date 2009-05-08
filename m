Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbZEHVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbZEHVdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZEHVdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:33:01 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34271 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbZEHVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:33:00 -0400
Date: Fri, 8 May 2009 23:35:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 09/14] x86, boot: add new runtime_address and runtime_size bzImage fields
Message-ID: <20090508213510.GB18712@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-10-git-send-email-hpa@linux.intel.com> <20090508075516.GF12808@uranus.ravnborg.org> <4A049F80.2090400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A049F80.2090400@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 02:09:20PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >> 	@:
> >>@@ -50,6 +53,9 @@ suffix_$(CONFIG_KERNEL_GZIP)  = gz
> >> suffix_$(CONFIG_KERNEL_BZIP2) = bz2
> >> suffix_$(CONFIG_KERNEL_LZMA)  = lzma
> >
> >No need for a recursive assignment here. Use ":="
> >Ann we usually uses "-y" not "_y".
> >
> 
> Wasn't part of the patch, but OK :)

I overlooked that fact - I often just review what I can see.
(In other words - I should have caught that detail when the original
patch was posted...)

	Sam
