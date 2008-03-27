Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYC0GJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYC0GJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 02:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYC0GJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 02:09:30 -0400
Received: from gw.goop.org ([64.81.55.164]:43980 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYC0GJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 02:09:30 -0400
Message-ID: <47EB3A10.4080403@goop.org>
Date: Wed, 26 Mar 2008 23:09:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
References: <47EAD83A.2000000@goop.org>	<20080327095059.5d2759a3.kamezawa.hiroyu@jp.fujitsu.com>	<47EB3765.8020702@goop.org> <20080327151115.be9f325d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080327151115.be9f325d.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> At first, I believe usual DIMM size is bigger than SECTION_SIZE_BITS. This is
> designed for hardware-based hotplug.
>
> If you want to use memory-hotplug for virtualized enviroment, it's good to make
> this to be smaller chunk. Powerpc/IBM lpar uses 16MB chunk.
>
> It's a trade-off between section mainainance cost v.s. size of plugged memory.
> please find the best.
>   

Yes, that's what I thought.  I'd been thinking of something around the 
64-256MB mark.  I'll experiment, but I've got some Xen-specific problems 
to solve first.

Thanks,
    J
