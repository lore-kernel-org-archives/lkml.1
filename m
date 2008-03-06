Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYCFUXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYCFUXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764172AbYCFUX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:23:26 -0500
Received: from gra-lx1.iram.es ([150.214.224.41]:58186 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbYCFUXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:23:24 -0500
From: Gabriel Paubert <paubert@iram.es>
Date: Thu, 6 Mar 2008 21:23:11 +0100
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jarod Wilson <jwilson@redhat.com>, benh@kernel.crashing.org,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
Message-ID: <20080306202311.GA18925@iram.es>
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802272221.38985.jwilson@redhat.com> <1204179959.15052.372.camel@pasglop> <200802281342.06493.jwilson@redhat.com> <1204241162.15052.393.camel@pasglop> <47C79CB1.6050104@redhat.com> <20080303091927.GA27105@iram.es> <47CC0C95.1030709@s5r6.in-berlin.de> <20080305225902.GA27985@iram.es> <47CF2C08.5000609@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF2C08.5000609@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:26:00AM +0100, Stefan Richter wrote:
> Gabriel Paubert wrote:
> >>>I have a Pismo which I use on a virtually
> >>>daily basis (and about to remove the last remnants of MacOS on it). 
> >>>However I have disabled Firewire because it would not sleep and wake 
> >>>up properly. 
> ...
> >For now I have only tested the new stack with a 6 year old 1.8" disk
> >and everything works, including suspend to RAM. The kernel is 2.6.25-rc4
> >plus additional pull from linux1394-2.6.git: 2.6.25-rc4-00032-g8d36ba4.
> 
> That's great.  Thanks for testing.

The old stack also works. I forgot to mention that with the new
stack (not with the old) there is a message when going to sleep:

firewire_ohci: pci_set_power_state failed with -5

but it is harmless, and if I understand correctly due to the 
fact that the power management on this chip is not implemented 
through capability fields in the PCI configuration space.

	Gabriel
