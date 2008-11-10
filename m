Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYKJKO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYKJKO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYKJKOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:14:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:61276 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYKJKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:14:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vS4t4Xi+NC81fYgc9CsJs2M6SJHKmPEwvF91gWOi8mhMkO+X8X6UZlvDC0JXKHk/gX
         OGebYduOJJoe2DzFHznvUQ0KuWS7PpajIK8zKah76ggeCENJw78AOa+S/SFwBtJDwZE6
         DyWP5B9PKDAIwPn/wmTR6Z9MkfPcJ4NW1BsUI=
Message-ID: <49180973.6080808@gmail.com>
Date: Mon, 10 Nov 2008 11:14:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
CC: linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: Re: Regression: Boot hang sizing transparent PCI-to-PCI bridge since
 after 2.6.25-r7.
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva>
In-Reply-To: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2008 10:12 AM, GARCIA DE SORIA LUCENA, JUAN JESUS wrote:
> Hello.
> 
> Time ago I bisected a commit that was making my OKI Anima 3300 laptop
> hang during boot.

Doesn't pci=norom help in your case? There was a patch which tried to resolve
this issue in a different manner, but it was reverted too. This boot parameter
was introduced as a replacement IIRC.

> The offending commit was:
> 
> ------------
> commit 12c22d6ef299ccf0955e5756eb57d90d7577ac68
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Mar 26 11:22:40 2008 -0700
> 
>     Revert "PCI: remove transparent bridge sizing"
> 
>     This reverts commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f, which
>     caused various interesting problems for people, including wrong
> resource
>     allocations.  See for example bugzilla entry "2.6.25-rc2: ohci1394
>     problem (MMIO broken)" at
> 
>         http://bugzilla.kernel.org/show_bug.cgi?id=10080
> 
> [...]
