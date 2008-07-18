Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYGRId2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYGRId2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYGRIdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:33:21 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51257 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbYGRIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:33:20 -0400
Date: Fri, 18 Jul 2008 09:33:17 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: Re: [PATCH 02/05] resource: add resource_type() and
	IORESOURCE_TYPE_BITS
Message-ID: <20080718083317.GN24620@fluff.org.uk>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se> <20080718074018.32713.11976.sendpatchset@rx1.opensource.se> <20080718075601.GL24620@fluff.org.uk> <aec7e5c30807180124j3623675fwaeedcaf23e4b0b05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30807180124j3623675fwaeedcaf23e4b0b05@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 05:24:59PM +0900, Magnus Damm wrote:
> On Fri, Jul 18, 2008 at 4:56 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> > You are changing a simple test to a mask and compare, is anyone going
> > to produce resources with an IORESOURCE_MEM and an IORESOURCE_IO
> > together?
> 
> Actually, I'd like to replace the one-bit-per-type strategy with a
> N-bit counter. But that is not very compatible with the case you are
> pointing out. I'm not sure if that's a combination we really want to
> support though. Both IRQ and DMA doesn't make much sense to me. =)

I'm not saying it is a bad idea, I just do not know if anyone is
currently relying on this to work... 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
