Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYJAApf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYJAApf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYJAAp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:45:26 -0400
Received: from ozlabs.org ([203.10.76.45]:43523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYJAApZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:45:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [RFC 1/1] cpumask: New cpumask API - take 2 - use unsigned longs
Date: Wed, 1 Oct 2008 10:45:22 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Miller <davem@davemloft.net>, Alan.Brunelle@hp.com,
       tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <48E269B6.1080904@sgi.com> <48E2A691.7060407@sgi.com>
In-Reply-To: <48E2A691.7060407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011045.22859.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 08:22:09 Mike Travis wrote:
> Here's an alternate proposal for the new cpumask API.  I have not yet begun
...
> +/* cpumask_t defaults to pointer to constant bit map */
> +typedef const unsigned long *cpumask_t;

Hiding a const here is not a good idea either, I think :(

Rusty.
