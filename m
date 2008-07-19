Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYGSNKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYGSNKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYGSNKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:10:40 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:55892 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753229AbYGSNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:10:39 -0400
Date: Sat, 19 Jul 2008 09:10:38 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macbook2,2 latest git mmconfig issues
Message-ID: <20080719131038.GA13168@bromo.msbb.uc.edu>
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com> <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com> <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com> <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,
   I never saw any error messages like that. If you are seeing the
same problem under 2.6.25 suddenly it might suggest a hardware
failure, no? That or something else has corrupted on your linux
volume. What happens if you boot from a linux rescue DVD? Does that
give the same error?
                      Jack

On Fri, Jul 18, 2008 at 11:54:38PM -0700, Justin Mattock wrote:
> applied both patches and messed with boot options
> but no go:
> this is what I'm seeing
> PCI: Fatal no config space access function found
> ata-piix 0000:00:1f11 device not available
> because of BAR0 [0xf0-0x1f7] collisions
> 
> 
> interesting how this kernel was running fine, and then
> BAM all of a sudden f*&^ed up, This tells me that this was something
> happening a while ago, or always happening just not
> noticed i.g. I plugged in 2.6.25-rc9(my favorite)
> and it too was giving the same response.
> after tracing back my steps the only application that might be causing
> this or hiding this is grub but could be wrong.
> 
> any ideas or patches would be appreciated, until further
> notice I'll be using osx until there is a
> regards;   : (
> 
> -- 
> Justin P. Mattock
