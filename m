Return-Path: <linux-kernel-owner+w=401wt.eu-S965640AbXCPQzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640AbXCPQzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXCPQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:55:42 -0400
Received: from gw.goop.org ([64.81.55.164]:36749 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965640AbXCPQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:55:41 -0400
Message-ID: <45FACC0D.3050103@goop.org>
Date: Fri, 16 Mar 2007 09:55:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for
 paravirt_ops interface
References: <20070301232443.195603797@goop.org> <20070316084251.GA23174@elte.hu>
In-Reply-To: <20070316084251.GA23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>  * virtual block device (blockfront)
>>  * virtual network device (netfront)
>>     
>
> note, these drivers should be submitted through the proper block drivers 
> and network drivers review process - not via the x86_64 tree.
>   

Yes; who should look at them?  I posted netfront to net-dev, and Stephen
Hemminger commented on it on the last repost, but I'd love them to get
more scrutiny.

Obviously they're not actually useful without Xen (and vice-versa), so
there's not much point in committing them separately.

    J
