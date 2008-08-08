Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYHHAYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYHHAYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHHAX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:23:56 -0400
Received: from gw.goop.org ([64.81.55.164]:52336 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbYHHAXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:23:55 -0400
Message-ID: <489B9208.2050802@goop.org>
Date: Thu, 07 Aug 2008 17:23:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org> <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org> <489B8EF4.1030105@goop.org> <489B8FAD.4090904@kernel.org>
In-Reply-To: <489B8FAD.4090904@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>> Having fixmaps at link-time fixed addresses would be nice, I suppose, 
>> but hardly worth going to vast effort over.
>>
>
> No, but it's hardly vast effort, either.

Well, off you go.

> Yes, and we should add a symbol for the bottom of the 1:1 area as well 
> (to disambiguate it from TASK_SIZE).
>

Well, that's already called "PAGE_OFFSET".  64-bit needs to be careful 
about the distinction anyway, because there's the sign extension hole 
between user and kernel space.  Xen squeezes itself in just above the 
hole, so I moved PAGE_OFFSET up accordingly.

    J
