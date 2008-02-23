Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbYBWVCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbYBWVCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761127AbYBWVC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:02:27 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:45034 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760063AbYBWVC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:02:26 -0500
Date: Sat, 23 Feb 2008 22:02:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Ilpo =?iso-8859-1?Q?J=E4rvinen'?=" <ilpo.jarvinen@helsinki.fi>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "'David Miller'" <davem@davemloft.net>,
       "'Arnaldo Carvalho de Melo'" <acme@redhat.com>
Subject: Re: [RFC PATCH 0/8]: uninline & uninline
Message-ID: <20080223210223.GA12148@basil.nowhere.org>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi> <20080223000220.e9229c99.akpm@linux-foundation.org> <p734pbz95lx.fsf@bingen.suse.de> <20080223105517.4d706511.akpm@linux-foundation.org> <00ac01c87656$777c02a0$667407e0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ac01c87656$777c02a0$667407e0$@com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 Feb 2008 20:55:57.0943 (UTC) FILETIME=[7D311070:01C8765E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it possible to catch this automatically, like, by re-defining
> likely/unlikely to the raw form in specific file(s)?

Sure it would be possible to define a IN_VDSO symbol in all vdso
related files and then do that. Might be useful for other things
too. vdso has some very specific requirements.

-Andi
