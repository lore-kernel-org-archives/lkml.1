Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYHJXqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYHJXqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 19:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHJXqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 19:46:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYHJXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 19:46:36 -0400
Message-ID: <489F7C2B.30807@zytor.com>
Date: Sun, 10 Aug 2008 16:39:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Wolfgang Walter <wolfgang.walter@stwm.de>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
References: <20080809220154.GO28946@ZenIV.linux.org.uk>	<E1KS2KD-0000he-00@gondolin.me.apana.org.au> <20080810133056.2fd69a20@neptune.home>
In-Reply-To: <20080810133056.2fd69a20@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont wrote:
> 
> Recompiling without viafb+squashfs patches makes the panic go away.
> 
> So something from viafb or squashfs triggers the panic or prepare
> for something else to trigger it...
> 

Out of those, viafb by far seems most likely.  Could you try compiling 
with only one or the other?

	-hpa
