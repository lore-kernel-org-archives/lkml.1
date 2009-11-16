Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZKPTFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZKPTFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZKPTFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:05:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZKPTFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:05:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Null suspend/resume functions
Date: Mon, 16 Nov 2009 20:07:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <20091109133136.GC1245@sirena.org.uk> <20091116153000.GB29479@sirena.org.uk>
In-Reply-To: <20091116153000.GB29479@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911162007.11963.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 November 2009, Mark Brown wrote:
> On Mon, Nov 09, 2009 at 01:31:36PM +0000, Mark Brown wrote:
> > On Mon, Nov 09, 2009 at 10:58:58AM +0000, Mark Brown wrote:
> > > On Mon, Nov 09, 2009 at 11:54:47AM +0900, Kuninori Morimoto wrote:
> 
> Any chance someone from the PM side could comment on the issue below?

There is.  I haven't had a chance to look at it yet, will do shortly.

> > > > +static int fsi_runtime_nop(struct device *dev)
> > > > +{
> > > > +	/* Runtime PM callback shared between ->runtime_suspend()
> > > > +	 * and ->runtime_resume(). Simply returns success.
> > > > +	 *
> > > > +	 * This driver re-initializes all registers after
> > > > +	 * pm_runtime_get_sync() anyway so there is no need
> > > > +	 * to save and restore registers here.
> > > > +	 */
> > > > +	return 0;
> > > > +}
> > > 
> > > This sets off alarm bells but it's perfectly reasonable, especially with
> > > platforms able to put things into a low power state with no explicit
> > > driver code now they can do power domain style things like SH.  I've
> > > CCed in the PM folks since this seems like a perfectly reasonable use
> > > case which ought to be handled more nicely.

Thanks,
Rafael
