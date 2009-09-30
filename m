Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZI3PJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZI3PJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZI3PJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:09:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575AbZI3PJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:09:18 -0400
Date: Wed, 30 Sep 2009 08:08:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make pty_driver and pty_slave_driver local vars in legacy
 BSD pty code
In-Reply-To: <20090930100147.28440.87231.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.01.0909300808110.6996@localhost.localdomain>
References: <20090930100147.28440.87231.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, David Howells wrote:
>
> Make the pty_driver and pty_slave_driver global variables into local vars of
> legacy_pty_init() as that's the only thing that ever accesses the values.

I had already done this in my local tree due to the other thread about the 
whole broken legacy pty initialization. Committed that and pushed out.

		Linus
