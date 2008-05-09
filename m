Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbYEIAS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbYEIAS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYEIASH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:18:07 -0400
Received: from outbound-mail-143.bluehost.com ([67.222.38.33]:38384 "HELO
	outbound-mail-143.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753649AbYEIASF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:18:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: regression fixed by using pci=rom
Date: Thu, 8 May 2008 17:17:53 -0700
User-Agent: KMail/1.9.9
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Gary Hade" <garyhade@us.ibm.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com>
In-Reply-To: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081717.54102.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2008 4:54 pm Dave Airlie wrote:
> A user just reported this bug
>
> http://bugs.freedesktop.org/show_bug.cgi?id=15523
>
> He says using pci=rom fixes the regression, do we truly have to start
> booting machines with this, sucks to be a distro..

Hm, yeah in many cases we definitely *do* want to try to get the expansion ROM 
space allocated.  But maybe it should be a lower priority than other BARs...  
Gary?

Thanks,
Jesse
