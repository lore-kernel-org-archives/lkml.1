Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZCDPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZCDPN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZCDPNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:13:21 -0500
Received: from mail.suse.de ([195.135.220.2]:39346 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZCDPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:13:20 -0500
Date: Wed, 4 Mar 2009 16:13:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jason Noble <nobleja@polezero.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: New HID device support
In-Reply-To: <1236178031.9121.6.camel@paradox.pz.local>
Message-ID: <alpine.LNX.2.00.0903041612210.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>  <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>  <1236107096.7793.1.camel@paradox.pz.local>  <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>  <1236172544.21288.3.camel@paradox.pz.local> 
 <alpine.LNX.2.00.0903041419250.4971@jikos.suse.cz>  <1236173654.21288.8.camel@paradox.pz.local>  <alpine.LNX.2.00.0903041436210.4971@jikos.suse.cz> <1236178031.9121.6.camel@paradox.pz.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Jason Noble wrote:

> I made a minor tweak. Please include in the official patch.
> (BTN_2 and BTN_3, are not very useful xev doesn't even see them)
> 
> -       case 0x01: ks_map_key(BTN_2);   break;
> -       case 0x02: ks_map_key(BTN_3);   break;
> +       case 0x01: ks_map_key(BTN_MIDDLE);   break;
> +       case 0x02: ks_map_key(BTN_SIDE);   break;
> 
> Other than that, it works great!
> 
> You are awesome, thank you very very much!!

Thanks for testing. I will put you in Reported-by:, if you don't mind, and 
queue the patch patch in my tree.

-- 
Jiri Kosina
SUSE Labs
