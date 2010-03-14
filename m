Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab0CNJeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 05:34:07 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:43741 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab0CNJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 05:34:04 -0400
X-Greylist: delayed 798 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Mar 2010 05:34:04 EDT
Date: Sun, 14 Mar 2010 05:20:24 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: micki@n-trig.com
Cc: jkosina@suse.cz, dmitry.torokhov@gmail.com, chatty@enac.fr,
       peterhuewe@gmx.de, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: HID: N-trig MTM Driver fix And cleanup patch 7 - comments
Message-ID: <20100314092023.GA16448@seas.upenn.edu>
References: <1268554937-3679-1-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268554937-3679-1-git-send-email-micki@n-trig.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 10:22:17AM +0200, micki@n-trig.com wrote:
> From: micki <micki@n-trig.com>
> 
> We reviewed all your comments with regard to our code and as mentioned in previous e-mail the relevant ones were fixed.

I'm glad you reviewed them.  Would you care to respond to any of the 
concerns that were raised?  While some may be inferable from your next 
patch submission there are definitely some questions that will need normal 
language to be addressed.

For example what functions do your proprietary closed source components 
perform that can not be reproduced with existing open or obvious 
algorithms and solutions?

I speak only for myself as an individual, but for that specific issue, I 
would need to see a very convincing argument of how that closed source 
module would improve my interactions with the computer, to move away from 
an open solution, particularly one which works rather well.
 
> Our driver works together with a user-space application which will be released as installation package suitable for
> 
> several Distros (RPM/DEB).

Will you provide source at release time, at least for the non-proprietary 
portions of your userpace solution.  Precompiled packages are convenient, 
but distibutions tend to prefer to have the option to repackage, not to 
mention reviewing the code before inclusion to their products.  
Furthermore lack of source makes it harder to debug _when_ things go 
wrong.
 
> The purpose of the package is to provide better performance and thus user-experience working with N-trig sensor.
> If you have any more comments about the code please send them to me, so I can update the patch.

That's particulary vague, I can come up 10 meanings of "better 
permformance" and few actually mean "noticably improve user experience".  
In what way will your stack make my computer work better for me?

Have you actually tried the current drivers in the kernel to be able to 
give an informed comparison?


I understand the reluctance to publish your user space tools before your 
kernel patches will permit them to work, I'm sure you don't want users 
reviewing and responding to something guaranteed to fail and all sorts of 
other image and liability issues.  However, its really difficult to 
evaluate the value of your changes without key components to actually see 
the improvements in action.

As has been said before, no one really wants to accept a patch that breaks 
existing support without an alternative.

But remember, there is a very clear intent to move towards a unified 
interface to the user space tools.  Simply having the alternative 
available will not prevent objections to breaking compatibility.


On a side note, is there any reason to wait to release the firmware 
loader?  I assume it does not actually depend on the hid kernel code to 
perform its function.


Rafi
