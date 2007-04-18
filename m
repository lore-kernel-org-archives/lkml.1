Return-Path: <linux-kernel-owner+w=401wt.eu-S1161434AbXDRB4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161434AbXDRB4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161436AbXDRB4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:56:52 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:44929 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161434AbXDRB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:56:51 -0400
Date: Tue, 17 Apr 2007 21:56:49 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: David Wagner <daw@cs.berkeley.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <f03mli$8g8$1@taverner.cs.berkeley.edu>
Message-ID: <Line.LNX.4.64.0704172143150.21359@d.namei>
References: <20070416213350.GB4030@suse.de> <1176822230.3366.65.camel@localhost.localdomain>
 <462553A9.70504@novell.com> <1176852059.5946.128.camel@localhost.localdomain>
 <f03mli$8g8$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, David Wagner wrote:

> Maybe you'd like to confine the PHP interpreter to limit what it can do.
> That might be a good application for something like AppArmor.  You don't
> need comprehensive information flow control for that kind of use, and
> it would likely just get in the way.

SELinux can do this, it's policy-flexible.  You can even simulate a 
pathame-based policy language with a consequential loss of control:

http://seedit.sourceforge.net/

> might well use AppArmor.  They solve different problems and have different
> tradeoffs.  There is room for more than one security tool in the world.

That is not the point of this discussion, although we can at least be 
thankful that Linus didn't request that the networking layer be pluggable 
to the extent that the security layer is, otherwise we'd have a menagerie 
of "better" TCP stacks, TOE frameworks, STREAMS modules and whatever other 
fantastic ideas that people might be inclined to drag out of the kitchen 
sink.


- James
-- 
James Morris
<jmorris@namei.org>
