Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYFJOmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYFJOmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYFJOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:41:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60150 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754304AbYFJOl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:41:57 -0400
Date: Tue, 10 Jun 2008 09:41:54 -0500
From: Jack Steiner <steiner@sgi.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 11/11] GRU Driver - makefile & Kconfig file changes
Message-ID: <20080610144154.GA29042@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com> <20080609211047.409885034@attica.americas.sgi.com> <adaod6a70mq.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaod6a70mq.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 02:35:09PM -0700, Roland Dreier wrote:
>  > +EXTRA_CFLAGS += -DDEBUG -Werror -Wall
> 
> Not sure if it's appropriate to set these flags for your driver...

Deleted. This was primarily for debugging. I moved the DEBUG option to
Kconfig as a driver DEBUG option that can be selected.


> 
>  > +	---help---
>  > +	This option enables basic support for the SGI UV GRU driver. If
>  > +	you are not running on a SGI UV system, say N.
> 
> "...enables basic support for the SGI UV GRU."  And it would be a good
> idea to include some info about what UV GRU does -- your 0/11
> introduction mail had a good description that would be nice to have here
> as well.

Done


--- jack
