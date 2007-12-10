Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbXLJT6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbXLJT6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXLJT5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:57:51 -0500
Received: from ns.suse.de ([195.135.220.2]:45743 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbXLJT5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:57:50 -0500
From: Andi Kleen <ak@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH RFC] [5/9] modpost: Fix a buffer overflow in modpost
Date: Mon, 10 Dec 2007 20:57:28 +0100
User-Agent: KMail/1.9.1
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de> <20071122024310.BB7E414D68@wotan.suse.de> <20071210193202.GC17315@uranus.ravnborg.org>
In-Reply-To: <20071210193202.GC17315@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712102057.29016.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 20:32, Sam Ravnborg wrote:
> On Thu, Nov 22, 2007 at 03:43:10AM +0100, Andi Kleen wrote:
> > When passing an file name > 1k the stack could be overflowed.
> > Not really a security issue, but still better plugged.
>
> Looks good. A s-o-b line again please.

Signed-off-by: Andi Kleen <ak@suse.de>

> Although I am not so happy with the ue of gcc extensions.

That's not a gcc extension. It's C99.

-Andi
