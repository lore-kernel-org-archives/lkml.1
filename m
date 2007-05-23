Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbXEWAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbXEWAk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbXEWAkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:40:18 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:21930 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbXEWAkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WhtIFD70N7AJNU7fNB15MGASlZZJ3OL43HlMapB2IUFX9CJIA4Wr7ARtSx9XddRwT6vAXyAXbBEtgokSMdRa1VstV5cCSChA30m5i2UFIZOCRyhfuU/APhDev4bWPFVcpWUw1Oa463uyG0xO1GKIQuwNgg/M6b80QJSYPHBR6A0=
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       dri-devel@lists.sourceforge.net, Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200705221636.20848.jbarnes@virtuousgeek.org>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705220839.04773.jbarnes@virtuousgeek.org>
	 <1179876398.32247.885.camel@localhost.localdomain>
	 <200705221636.20848.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 08:40:08 +0800
Message-Id: <1179880808.4638.5.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 16:36 -0700, Jesse Barnes wrote:
> On Tuesday, May 22, 2007, Benjamin Herrenschmidt wrote:
> > On Tue, 2007-05-22 at 08:39 -0700, Jesse Barnes wrote:
> > > The current code does its best to figure out what modes are available
> > > and tries to pick a good one for each display.  It sounds like you're
> > > mainly concerned with the actual mode picking, not the mode and output
> > > detection and enumeration?  If so, that's a pretty easy change to
> > > make.  But if you're also worried about the kernel building mode
> > > lists, then we'll have bigger changes to make...
> >
> > I'm worried that the EDID we get from the monitor is bogus and needs to
> > be overriden.
> >
> > Now, if the kernel builds a mode list, that's find if we have a call to
> > "feed" it with a replacement one later on from userland.
> >
> > In addition, there are all those monitors that cannot be probed (no
> > DDC/EDID) and for which only userland can reasonably provide a mode or a
> > mode list.
> 
> Yeah, we already have a call to add modes to the kernel's list, so we 
> should be covered.
> 

We actually have a function that will replace the entire mode list with
a new one safely.

Tony


