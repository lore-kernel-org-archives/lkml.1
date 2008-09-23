Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYIWWHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYIWWHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYIWWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:07:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56494
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYIWWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:07:34 -0400
Date: Tue, 23 Sep 2008 15:07:22 -0700 (PDT)
Message-Id: <20080923.150722.141587696.davem@davemloft.net>
To: airlied@gmail.com
Cc: jkosina@suse.cz, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>
References: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
	<20080923.140519.268233735.davem@davemloft.net>
	<21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Wed, 24 Sep 2008 07:09:09 +1000

> On Wed, Sep 24, 2008 at 7:05 AM, David Miller <davem@davemloft.net> wrote:
> > From: Jiri Kosina <jkosina@suse.cz>
> > Date: Tue, 23 Sep 2008 16:29:16 +0200 (CEST)
> >
> >> On Mon, 22 Sep 2008, David Miller wrote:
> >>
> >> > So I went through the changes from 2.6.27-rc5 until the SHA1
> >> > ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
> >> > definitely no E1000 or E1000E changes during that time.
> >>
> >> Some recent comments on [1] seem to indicate that this is somehow coupled
> >> into prior problems/panics with Intel graphics.
> >
> > My current suspicion in all of this is either the GEM kernel patches
> > or recent X server.
> >
> 
> I don't think OpenSUSE was shipping any of the GEM bits.

Good data point, can someone confirm this?  Also, what X server version
is the effected OpenSUSE shipping?
