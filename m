Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbYARPzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbYARPzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYARPzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:55:24 -0500
Received: from gw.goop.org ([64.81.55.164]:48793 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYARPzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:55:23 -0500
Message-ID: <4790CBE9.3000409@goop.org>
Date: Fri, 18 Jan 2008 07:55:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 4 of 4] x86: mask NX from pte_pfn
References: <b27ec2092a01dc15e139.1200435429@localhost> <Pine.LNX.4.64.0801181350090.27929@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0801181350090.27929@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Shouldn't that be
>
> 	return (pte_val(pte) & ~_PAGE_NX) >> PAGE_SHIFT;
>   

Yes, it should be.

Thanks,
    J
