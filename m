Return-Path: <linux-kernel-owner+w=401wt.eu-S937005AbYEBVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937005AbYEBVLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936683AbYEBVLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:11:22 -0400
Received: from gw.goop.org ([64.81.55.164]:50644 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935708AbYEBVLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:11:21 -0400
Message-ID: <481B8376.4050206@goop.org>
Date: Fri, 02 May 2008 14:11:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Tom Rini <trini@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: huge gcc 4.1.{0,1} __weak problem
References: <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com> <20080501154238.eccdb6ff.akpm@linux-foundation.org> <20080501232116.GD4354@smtp.west.cox.net> <20080501233038.GA20601@linux-os.sc.intel.com> <alpine.LFD.1.10.0805011729540.5994@woody.linux-foundation.org> <20080502003947.GB28173@linux-os.sc.intel.com>
In-Reply-To: <20080502003947.GB28173@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, May 01, 2008 at 05:34:34PM -0700, Linus Torvalds wrote:
>   
>> Is it always about inlining? If so, can't we add a __noinline__ to the 
>> declaration of __weak?
>>     
>
> We tried that and it was still getting inlined.

That's a pity.  I've worked around this bug with noinline before.

    J
