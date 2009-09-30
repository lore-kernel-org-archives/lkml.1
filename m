Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZI3WqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZI3WqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZI3WqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:46:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZI3WqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:46:06 -0400
Message-ID: <4AC3DF7B.5060407@zytor.com>
Date: Wed, 30 Sep 2009 15:45:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH,TRIVIAL] Fix csum_ipv6_magic asm memory clobber
References: <20090926192748.GX7681@const.famille.thibault.fr> <20090930154044.0c7ace16.akpm@linux-foundation.org>
In-Reply-To: <20090930154044.0c7ace16.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 03:40 PM, Andrew Morton wrote:
> 
> You describe it as "trivial" and also cc stable@kernel.org.  These things
> are contradictory!
> 
> Maybe backporting it is a good idea from a sleep-soundly-at-night POV. 
> I don't know..
> 

/me suspects it was supposed to mean "trivially correct", which isn't
really what "trivial" means.  This is a potentially serious bug and
should be treated as such.

	-hpa
