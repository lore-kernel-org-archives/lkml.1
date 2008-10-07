Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJGLiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJGLiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYJGLhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:37:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:14400 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJGLhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kG6ad10B/R8FuJN9njbG9EqGiX4I0+hbafluYm0gnbLmg5snCOiGmwE3XfcPaKvQLS
         vhmuwLGVpw6LA6gjYiBkqx+rs4mXDHa0Q8hxSsXAEXomhjbi/ki/OLM5GdUAEE0Y/Kpe
         9V7l119qwvXYqDzY3E3/xZy3V6BcSsBg4nuf0=
Date: Tue, 7 Oct 2008 07:37:47 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081007113747.GA2819@amd.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv> <20081005121046.579089b9@infradead.org> <20081006062838.GC2808@amd.corenet.prv> <20081006195350.GB22097@alberich.amd.com> <20081007034230.GA6095@amd.corenet.prv> <20081007091032.GD22097@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007091032.GD22097@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:10:32AM +0200, Andreas Herrmann wrote:
> >On Mon, Oct 06, 2008 at 11:42:35PM -0400, Dmitry Torokhov wrote:
> > On Mon, Oct 06, 2008 at 09:53:50PM +0200, Andreas Herrmann wrote:
> > > 
> > > FYI.
> > > Commit e7250b8ae3870f37f660c2f65cafcaba85e3bfd3 of tip/master is
> > > needed to really enable hpet on SB400. I guess that patch should go
> > > upstream asap -- and probably it's a good idea to add a check for timer
> > > interrupt routing as well which could solve the issues on HP nx6xxx
> > > laptops.
> > > 
> > 
> > Having trouble locating this one. Could you please send me a patch so I
> > can try it here? Thanks!
> 
> Here it is.
> 

Hmm, that unfortunately does not work because I have SB4X0 revision 0x11
and the patch cuts off everything below 0x82. Is there anything that can
be done to enable HPET on early revisions?

Thanks.

-- 
Dmitry
