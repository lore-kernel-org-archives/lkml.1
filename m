Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYFXVaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYFXVaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYFXV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:29:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:35433 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbYFXV3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LEgK3OJsfQfJsRbIij4UIjfQ5D8iuzNkK688NXmBpufBHpVlyCY6QvVf+hE2AoBTzY
         4KsjR4r6S4mth1WbKLi0GSzWZ52Ioh4N+WZjd1bOLXDBQj4998k4hQXE1IZLYAwCFd4i
         YgKWhUBme9S/RuQf7fW56cfT1y80ZKTG5PYj8=
Message-ID: <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>
Date: Tue, 24 Jun 2008 14:29:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
In-Reply-To: <20080623060939.6b6b3183.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	 <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	 <20080623060939.6b6b3183.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 4:09 AM, Paul Jackson <pj@sgi.com> wrote:
> Yinghai wrote:
>> we should remove 0x,
>
> I see some kernel hex prints either way, with or without, 0x.
>
> In this case, in part because I was changing a decimal to a hex
> format, and because it could be ambiguous (a hex number that
> happened to use only [0-9] digits would be indistinguisable from
> a decimal) I preferred using the 0x.
>
> I see no clear answer here ... it seems to be a matter of taste.
>
>> we should ... hex print out all the way...regarding mem pfn and
>> memory address, memory size etc. except XXXMB. XXXKB...
>
> I fixed the ones I noticed.  If you see print formats that you
> would like to change, I will likely be in agreement to such a
> patch.

got

Zone PFN ranges:
  DMA      0x       0 -> 0x    1000
  DMA32    0x    1000 -> 0x  100000
  Normal   0x  100000 -> 0x  428000
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x       0 -> 0x      99
    0: 0x     100 -> 0x   d7fa0
    0: 0x   d7fae -> 0x   d7fb0
    0: 0x  100000 -> 0x  228000
    1: 0x  228000 -> 0x  428000

YH
