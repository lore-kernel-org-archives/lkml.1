Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbYDXOOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbYDXOOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYDXOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:14:06 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:12761 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbYDXOOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:14:04 -0400
From: Frans Pop <elendil@planet.nl>
To: penberg@cs.helsinki.fi
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Date: Thu, 24 Apr 2008 16:13:25 +0200
User-Agent: KMail/1.9.9
Cc: zaitcev@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, gregkh@suse.de, clameter@sgi.com
References: <200804212310.41729.elendil@planet.nl> <20080423101123.a69e4945.zaitcev@redhat.com> <84144f020804231035w3fdb10aax4b90dc4e0bc1957d@mail.gmail.com> <84144f020804231035w3fdb10aax4b90dc4e0bc1957d@mail.gmail.com> <200804232015.27257.elendil@planet.nl>
In-reply-To: <200804232015.27257.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241613.26557.elendil@planet.nl>
X-OriginalArrivalTime: 24 Apr 2008 14:13:27.0005 (UTC) FILETIME=[5D4F20D0:01C8A615]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Wednesday 23 April 2008, Pekka Enberg wrote:
>> Well, a race in mon_text_release() after the kmem_cache_free() loop
>> and the call to kmem_cache_destroy() but looks like that can't happen
>> either. Frans, is this easily triggerable? If so, can you try with
>> CONFIG_SLAB and CONFIG_DEBUG_SLAB enabled instead?
> 
> Not really. I've only seen it once two days ago and not at all today while
> I was doing the traces for the scheduling issue.

I've run with the same kernel for about 6 hours today but not seen the 
WARNING again, so the chance that I'll be able to provide additional info 
is close to zero :-(
Maybe I'll have more "luck" later in the .26 cycle when I start using -rc 
releases on a daily basis.
