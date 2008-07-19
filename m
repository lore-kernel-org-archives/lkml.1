Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYGSPPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYGSPPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYGSPOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:14:55 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:46214 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754748AbYGSPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:14:54 -0400
Date: Sat, 19 Jul 2008 11:14:53 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macbook2,2 latest git mmconfig issues
Message-ID: <20080719151453.GA13792@bromo.msbb.uc.edu>
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com> <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com> <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com> <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com> <20080719131038.GA13168@bromo.msbb.uc.edu> <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 07:53:34AM -0700, Justin Mattock wrote:
> >
> 
> could be; but  loading an iso works i.g.
> after installing it and starting up.
> these two messages came from after applying
> the two patches(keep in mind I was tired so maybe
> plugged them in wrong) before the two patches
> the MMCONFIG disable message with f0000000
> that you where receiving. maybe the manufacture
> on mine needs to be MacBookPro2,2 and the 0x3f
> needs to be 0x1f. Where do I find these numbers
> and names on the system? I've done dmidecode
> but can't seem to make out any of the info
> 
> -- 
> Justin P. Mattock

Justin,
   I am attempting to build kernel rpms with tip right now.
My first effort would boot because somehow the modules weren't
being found (paths were being used with -tip in them). I've removed
the localversion file from the top level of tip and hope that fixes
the packaging issues. This issue didn't occur when I used a git
from the linus kernel branch.
                            Jack
