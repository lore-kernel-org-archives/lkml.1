Return-Path: <linux-kernel-owner+w=401wt.eu-S935821AbXJPX1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821AbXJPX1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXJPX0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:26:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbXJPX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:26:53 -0400
Date: Tue, 16 Oct 2007 16:26:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, krzysztof.h1@wp.pl, perex@perex.cz
Subject: Re: suspicious ALSA empty commit
In-Reply-To: <20071016.155044.82377336.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
References: <20071016.155044.82377336.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2007, David Miller wrote:
> 
> While scanning over today's updates in Linus's tree, I noticed
> the following commit has no changes, and this does not appear
> to be intentional.

Interesting. You're right, I didn't notice.

Git shouldn't even allow such commits to be generated, although you can 
force it by using the low-level functionality (eg using "git commit-tree" 
directly for doing things like importing)

			Linus
