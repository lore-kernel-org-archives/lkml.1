Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbXERA5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbXERA5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbXERA5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:57:01 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:38617 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754336AbXERA5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:57:00 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [PATCH 1/3] allow console unregistration
Date: Thu, 17 May 2007 17:56:47 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       Jakob Bornecrantz <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com> <200705171532.28799.jesse.barnes@intel.com> <1179444190.5092.4.camel@daplas>
In-Reply-To: <1179444190.5092.4.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171756.48079.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007, Antonino A. Daplas wrote:
> On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> > Randy just informed me that the patch limits are bigger now, so here
> > are the actual patches.
> >
> > This patch allows for proper console unregistration via the VT layer,
> > and updates the FB layer to use it.  This makes debugging new console
> > drivers much easier, since you can properly clean them up before
> > unloading. Antonio already checked it out (and suggested a tweak for
> > the fbcon side) so I think it's on its way already via the FB tree.
>
> Sorry, I was busy and got sidetracked so I wasn't able to work on this
> for 2 weeks.  Yes, this should work for now, at least for debugging
> purposes. I'll work on refining on fbcon side, hopefully for
> 2.6.22-2.6.23 time frame.

No problem, I don't expect the rest of the code to be ready for awhile... 
This patch should be pretty close (modulo debugging statements and other 
bogons) to what we discussed earlier.  I think the main change that's 
needed is to only unregister the specific console that was registered, 
rather than all of them.

Thanks,
Jesse
