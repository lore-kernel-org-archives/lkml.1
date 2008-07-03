Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYGCVxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYGCVxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYGCVxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:53:36 -0400
Received: from gw.goop.org ([64.81.55.164]:60597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbYGCVxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:53:35 -0400
Message-ID: <486D4A58.60003@goop.org>
Date: Thu, 03 Jul 2008 14:53:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, xen-devel@lists.xensource.com,
       xen-ia64-devel@lists.xensource.com, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] xen: portability clean up and some minor clean up for
 xencomm.c
References: <20080703071209.GD15683%yamahata@valinux.co.jp>
In-Reply-To: <20080703071209.GD15683%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> clean up of xencomm.c. is_phys_contiguous() is arch dependent
> function that depends on how virtual memory are laid out.
> So split out the function into arch specific code.
>   

I suppose.  But given that ia64 is the only user of xencomm, I'm not too 
concerned about it.  And unless Arm uses it, I suspect it may always be 
the only user...

    J
