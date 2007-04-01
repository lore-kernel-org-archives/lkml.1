Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXDAGCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXDAGCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbXDAGCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:02:08 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57932 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451AbXDAGCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:02:07 -0400
Message-ID: <460F58B2.7020607@vmware.com>
Date: Sat, 31 Mar 2007 23:01:06 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VMI paravirt-ops bugfix for 2.6.21
References: <460E1FC7.5030107@vmware.com> <200703311635.01776.ak@suse.de>
In-Reply-To: <200703311635.01776.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I think I would prefer you touch the generic code. This new hook is ugly.
>   

What new hook?  The hook has been there for sometime, and now we are 
using it to fix a bug.  I do not want to touch generic or arch code at 
this point in the 2.6.21 release.

> And the lazy mode is currently only used by VMI anyways, isn't it? So you shouldn't 
> impact anybody else
>   

Yes, but if I don't touch arch code, I won't even affect native.  I do 
not want to risk any instability, despite how easy it would be to do 
what you and others have asked, I don't think it is appropriate at -rc5 
stage.

Thanks,
Zach
