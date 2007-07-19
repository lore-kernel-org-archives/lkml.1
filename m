Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXGSM0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXGSM0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXGSM0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:26:10 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:51859
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607AbXGSM0J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:26:09 -0400
Message-Id: <469F6669020000780003960B@public.id2-vpn.continvity.gns.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 19 Jul 2007 13:25:59 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <prasanna@in.ibm.com>, <mathieu.desnoyers@polymtl.ca>, <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: new text patching for review
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I like this approach much better, just one small note (I think I
had the same mistake in my changes initially):

>@@ -202,7 +209,7 @@ static void alternatives_smp_lock(u8 **s
> 			continue;
> 		if (*ptr > text_end)
> 			continue;
>-		**ptr = 0xf0; /* lock prefix */
>+		text_poke(ptr, 0xf0); /* lock prefix */
> 	};
> }
 
You probably want *ptr here.

Jan
