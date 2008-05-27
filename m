Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYE0CIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYE0CIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 22:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYE0CIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 22:08:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49519 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYE0CIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 22:08:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Date: Tue, 27 May 2008 11:17:22 +1000
User-Agent: KMail/1.9.9
Cc: Daniel Walker <dwalker@mvista.com>, linville@tuxdriver.com, matthew@wil.cx,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
References: <20080522232103.120033152@mvista.com> <20080526192914.31045d09@brian.englab.brq.redhat.com>
In-Reply-To: <20080526192914.31045d09@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271117.23051.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008 03:29:14 Michal Schmidt wrote:
> Mutexes are not allowed in interrupt context, not even mutex_trylock.

As an aside, does anyone know why?  I know the documentation says so, but it 
wasn't immediately obvious to me.  I asked before to no response...

Thanks,
Rusty.
