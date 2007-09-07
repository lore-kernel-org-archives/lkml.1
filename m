Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbXIGQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbXIGQng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbXIGQn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:43:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:40022 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbXIGQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:43:28 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <200709061807.33740.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709061157.44080.vda.linux@googlemail.com>
	 <1189091630.8490.1.camel@imap.mvista.com>
	 <200709061807.33740.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 09:31:11 -0700
Message-Id: <1189182671.6303.42.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 18:07 +0100, Denys Vlasenko wrote:

> A bit extended version:
> 
> In the process in making it work I saw ~10% vmlinux size reductions
> (which basically matches what Marcelo says) when I wasn't retaining
> sections needed for EXPORT_SYMBOLs, but module loading didn't work.
> 
> Thus I fixed that by adding KEEP() directives so that EXPORT_SYMBOLs
> are never discarded. This was just one of many fixes until kernel
> started to actually boot and work.
> 
> I did that before I posted patches to lkml.
> IOW: posted patches are not broken versus module loading.

Ok, this is more like the explanation I was looking for..

During this thread you seemed to indicate the patches you release
reduced the kernel ~10% , but now your saying that was pre-release ,
right? 

Daniel

