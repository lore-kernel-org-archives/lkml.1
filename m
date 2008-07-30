Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYG3Viw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYG3Viw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYG3Vio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:38:44 -0400
Received: from styx.suse.cz ([82.119.242.94]:60279 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbYG3Vin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:38:43 -0400
Date: Wed, 30 Jul 2008 23:38:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland Dreier <rdreier@cisco.com>
cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
In-Reply-To: <ada3alrys8d.fsf@cisco.com>
Message-ID: <alpine.LNX.1.10.0807302334430.3768@jikos.suse.cz>
References: <20080729143015.0f79cf37@bike.lwn.net> <Pine.LNX.4.64.0807301307060.26427@twin.jikos.cz> <20080730145600.7b61a43a@bike.lwn.net> <ada3alrys8d.fsf@cisco.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Roland Dreier wrote:

> I think Linus has said pretty explicitly that he is willing to merge new 
> low-level hardware drivers at pretty much any stage, as long as they are 
> obviously self-contained and can't break anything.

Well, I think I understand a little bit this fear of merging new driver 
that "obviously can't break anything" in arbitrary stage od development. 
See below.

> As an example of this, the UVC webcam driver was one of the very last 
> things merged just before the final 2.6.26 release, very late in the 
> release cycle.

If you have a hardware that hasn't been supported by the previous kernel 
versions at all, then everything is fine, just no driver is bound to the 
device, and the device doesn't work. If then -rc9 comes with a shiny new 
driver for this hardware, it gets autoloaded. If it is buggy, your system 
crashes. This is regression, right?

Nevertheless, I still think that merging new drivers as fast as possible 
is a good thing (tm).

Thanks,

-- 
Jiri Kosina
SUSE Labs
