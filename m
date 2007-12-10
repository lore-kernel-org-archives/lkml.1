Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbXLJUGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbXLJUGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXLJUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:05:58 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39259 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451AbXLJUF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:05:56 -0500
Date: Mon, 10 Dec 2007 21:07:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH RFC] [5/9] modpost: Fix a buffer overflow in modpost
Message-ID: <20071210200746.GA17700@uranus.ravnborg.org>
References: <20071122343.446909000@suse.de> <20071122024310.BB7E414D68@wotan.suse.de> <20071210193202.GC17315@uranus.ravnborg.org> <200712102057.29016.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712102057.29016.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 08:57:28PM +0100, Andi Kleen wrote:
> On Monday 10 December 2007 20:32, Sam Ravnborg wrote:
> > On Thu, Nov 22, 2007 at 03:43:10AM +0100, Andi Kleen wrote:
> > > When passing an file name > 1k the stack could be overflowed.
> > > Not really a security issue, but still better plugged.
> >
> > Looks good. A s-o-b line again please.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> > Although I am not so happy with the ue of gcc extensions.
> 
> That's not a gcc extension. It's C99.

OK.
I have applied all three patches to kbuild.git.

As I did not follow the whole thread about the namespace I did not
take those.
And the first patch touching module.c should go in via akpm I think.
It is outside my core-competence area at least .

	Sam
