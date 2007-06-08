Return-Path: <linux-kernel-owner+w=401wt.eu-S968832AbXFHLcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968832AbXFHLcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967847AbXFHLby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:31:54 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:42047 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966999AbXFHLbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:31:53 -0400
From: "Goede, J.W.R. de" <j.w.r.degoede@hhs.nl>
Subject: Re: problem with softraw and keycodes > 128
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.6
Date: Fri, 08 Jun 2007 13:31:50 +0200
Message-ID: <web-68582106@hhs.nl>
In-Reply-To: <20070607191648.GC18372@suse.cz>
References: <4667C00D.40708@hhs.nl>
 <20070607131503.GA26905@suse.cz>
 <46681C5B.80201@hhs.nl>
 <20070607153639.GB5775@suse.cz>
 <466848F6.9010707@hhs.nl>
 <20070607191648.GC18372@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 08062007 #319859, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 21:16:48 +0200
 Vojtech Pavlik <vojtech@suse.cz> wrote:
> On Thu, Jun 07, 2007 at 08:05:42PM +0200, Hans de Goede
> wrote:
>  
> > This is an atkbd only setting, right, so indeed it
> doesn't affect USB, 
> > right?
> 
> Right, what I meant is that USB keyboards are affected by
> the very same
> problem you describe (163 in kernel will be 153 in X),
> and it can't be
> worked around by setting softraw to 0.
> 

Yes, I see I've been thinking about this some more and I 
tend to agree that doing the mapping at the kernel and
always represent an identical keyboard (fake)scancode wise,
is indeed the best way forward.

You said that someone at Suse is working on this, can you
disclose his mail address, I would like to help, atleast by
testing and I can probably do more then just that.

Thanks & Regards,

Hans


