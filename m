Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZCRFfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZCRFfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 01:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZCRFes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 01:34:48 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60053 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502AbZCRFer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 01:34:47 -0400
Message-ID: <49C087F3.3080507@snapgear.com>
Date: Wed, 18 Mar 2009 15:34:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
References: <200903120437.03837.rob@landley.net> <200903161521.00036.rob@landley.net> <49BEDC75.1080704@snapgear.com> <200903172304.00157.rob@landley.net>
In-Reply-To: <200903172304.00157.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Rob Landley wrote:
> On Monday 16 March 2009 18:10:45 Greg Ungerer wrote:
>>>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>>>> fix-includes
> ...
>> Did you get the "fix-includes" branch?
> 
> Quite possibly not.  (I'm not a git person.)
> 
> I did a "git clone git://blah fix-includes" of the branch you gave a URL to, 
> checked for tags and saw nothing particularly interesting, did a log -v and 
> exported an archive of the most recent commit, and built it.
> 
> (Just tried it again with the same result.)
> 
> What _should_ I have done?

The git clone you have done will just get the master branch,
and put it in a directory named fix-includes.

Which is ok, but you still won't have the "fix-includes" branch.
Do this after the clone:

   git pull 
git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git 
fix-includes

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
