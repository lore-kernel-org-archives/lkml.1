Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYAOJLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYAOJLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYAOJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:11:23 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:9644
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYAOJLW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:11:22 -0500
Message-Id: <478C86E0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 15 Jan 2008 09:11:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <ak@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [0/31] Great change_page_attr patch series v2
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 14.01.08 23:16 >>>
>
>Lots of improvements to change_page_attr(). Make it a lot more
>efficient and fix various bugs.
>
>Changes against earlier version
>
>- Fixed some checkpatch.pl complaints
>- Improved self test suite
>- Fixed more reference bugs 
>- Fix NX handling on 32bit
>- Remove some useless code there
>- Few other random fixes

The one concept that I'm missing (but that I can easily produce a follow-up
patch for, as I had this in my c_p_a() changes) is the tracking and adjusting
of the reference protection for a large page range that got fully converted
to another type (namely relevant for .rodata if it exceeds 2/4 Mb), allowing
to use a large page mapping in this case even for non-default mappings.

Apart from the other comments, the whole series

Acked-by: Jan Beulich <jbeulich@novell.com>

