Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYFIQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYFIQIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYFIQIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:08:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43106 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbYFIQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:08:23 -0400
Message-ID: <484D5578.7070709@sgi.com>
Date: Mon, 09 Jun 2008 09:08:24 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Replace xxx_pda() operations with	x86_xx_percpu().
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.711845000@polaris-admin.engr.sgi.com> <20080609130302.GA20943@elte.hu>
In-Reply-To: <20080609130302.GA20943@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>   * It is now possible to use percpu operations for pda access
>>     since the pda is in the percpu area. Drop the pda operations.
> 
> FYI, this one didnt build with the attached config.
> 
> 	Ingo
> 

Ok, thanks, I will check it out.

I'm still having problems getting your previous "instantaneous
reboot" problem working.  It has something to do with cpu_clock
interrupt, but I've still not figured out why it's failing.

THanks,
Mike
