Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYDWSQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYDWSQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYDWSPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:15:32 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:11362 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbYDWSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:15:29 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Date: Wed, 23 Apr 2008 20:15:26 +0200
User-Agent: KMail/1.9.9
Cc: "Pete Zaitcev" <zaitcev@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       "Christoph Lameter" <clameter@sgi.com>
References: <200804212310.41729.elendil@planet.nl> <20080423101123.a69e4945.zaitcev@redhat.com> <84144f020804231035w3fdb10aax4b90dc4e0bc1957d@mail.gmail.com>
In-Reply-To: <84144f020804231035w3fdb10aax4b90dc4e0bc1957d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804232015.27257.elendil@planet.nl>
X-OriginalArrivalTime: 23 Apr 2008 18:15:27.0754 (UTC) FILETIME=[01EFD6A0:01C8A56E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Pekka Enberg wrote:
> Well, a race in mon_text_release() after the kmem_cache_free() loop
> and the call to kmem_cache_destroy() but looks like that can't happen
> either. Frans, is this easily triggerable? If so, can you try with
> CONFIG_SLAB and CONFIG_DEBUG_SLAB enabled instead?

Not really. I've only seen it once two days ago and not at all today while I 
was doing the traces for the scheduling issue.

I can give it a go, but I'm not yet ready to switch to current git on this 
box for longer periods (although so far I've actually had less issues than 
with .24-rc1; fingers crossed). If I get anything I'll follow up.
