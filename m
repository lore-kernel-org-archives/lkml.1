Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYGUTPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYGUTPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYGUTNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:13:53 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60554 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbYGUTNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:13:50 -0400
Message-ID: <4884DFEE.4060003@lwfinger.net>
Date: Mon, 21 Jul 2008 14:13:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Schram <ischram@telenet.be>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <20080721134506.GA27598@elte.hu> <20080721143023.GA32451@elte.hu> <20080721150446.GA17746@elte.hu> <20080721.082419.70392960.davem@davemloft.net> <4884D2F1.2030704@telenet.be> <20080721190646.GA19044@elte.hu>
In-Reply-To: <20080721190646.GA19044@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ian Schram <ischram@telenet.be> wrote:
> 
>> I was looking at this out of interest, but I'm in no way familiar with 
>> the code.
> 
> thanks Ian for the patch, i'll test it.
> 
> Note that it was whitespace damaged, find below a tidied up version of 
> the patch that i've applied to tip/out-of-tree.
> 
> 	Ingo

This patch may be needed to fix error handling in the hw_sim code, but I get the 
crash even with that code disabled. I'm currently bisecting to find the culprit.

Larry
