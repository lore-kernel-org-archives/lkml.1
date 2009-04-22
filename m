Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZDVU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZDVU45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZDVU4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:56:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36370 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZDVU4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:56:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH v2 fixed] e100: do not go D3 in shutdown unless system is powering off
Date: Wed, 22 Apr 2009 22:55:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
References: <1240237621-11415-1-git-send-email-cascardo@holoscopio.com> <20090422193728.GI4691@vespa.holoscopio.com> <9929d2390904221322v1c00b0c8see98efb4354cb173@mail.gmail.com>
In-Reply-To: <9929d2390904221322v1c00b0c8see98efb4354cb173@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904222255.55508.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009, Jeff Kirsher wrote:
> On Wed, Apr 22, 2009 at 12:37 PM, Thadeu Lima de Souza Cascardo
> <cascardo@holoscopio.com> wrote:
> > On Tue, Apr 21, 2009 at 10:46:19PM -0700, Jeff Kirsher wrote:
> >> On Tue, Apr 21, 2009 at 9:38 PM, Thadeu Lima de Souza Cascardo
> >> <cascardo@holoscopio.com> wrote:
> >> > After experimenting with kexec with the last merges after 2.6.29, I've
> >> > had some problems when probing e100. It would not read the eeprom. After
> >> > some bisects, I realized this has been like that since forever (at least
> >> > 2.6.18). The problem is that shutdown is doing the same thing that
> >> > suspend does and puts the device in D3 state. I couldn't find a way to
> >> > get the device back to a sane state in the probe function. So, based on
> >> > some similar patches from Rafael J. Wysocki for e1000, e1000e and ixgbe,
> >> > I wrote this one for e100.
> >> >
> >> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> >> > ---
> >>
> >> Thanks, I will add it to my queue of patches for e100.
> >>
> >> Also, just FYI, Auke is no longer a maintainer for
> >> e100/e1000/e1000e/igb/ixgb/ixgbe devices, so I have removed him from
> >> the thread.
> >>
> >> --
> >> Cheers,
> >> Jeff
> >
> > Perhaps, Rafael should be mentioned in a Reviewed-by? As well as you if
> > you did review it? I guess a Tested-by and Reported-by me is overkill,
> > right? :-)
> >
> 
> Correct, that would be overkill.  If Rafael wants his Ack or
> Reviewed-by added, he will let us know.

Please add my ACK to the patch.

Best,
Rafael
