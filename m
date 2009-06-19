Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbZFSWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbZFSWj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761043AbZFSWhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:37:54 -0400
Received: from alva.zappa.cx ([213.88.132.89]:49142 "EHLO alva.zappa.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761142AbZFSWhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:37:53 -0400
Message-ID: <4A3C1343.10501@zappa.cx>
Date: Sat, 20 Jun 2009 00:37:55 +0200
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30 kernel panic when closing lid
References: <4A3BF368.9090103@zappa.cx> <200906192356.28453.elendil@planet.nl>
In-Reply-To: <200906192356.28453.elendil@planet.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Andreas Sundstrom wrote:
>> My laptop has started crashing when I close the lid. This does not
>> happen with 2.6.29.4 which I was using before 2.6.30, I configured my
>> 2.6.30 kernel with the 2.6.29.4 as the base and then did "make
>> oldconfig" and then most of the questions I got I used the default
>> setting.
> 
> That sounds like it may be a known issue, although it's somewhat strange 
> that you did not see it with earlier kernels.
> Can you test if the following workaround fixes the crash?
> 
> echo -n 7 >/proc/acpi/video/C09A/DOS
> 
> See e.g.: http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/01971.html
> You can find more information by googling for "hp 2510p lid close crash"
> (but it affects other models as well).
> 
> Cheers,
> FJP

I think you hit the nail on the head there.. It seems to work now with
DOS set to 7 instead of 0 as it defaults to.

Funny thing is that I know remember going through this issue some time
ago.. I have since then changed from ubuntu to debian lenny. It used to
be taken cared of by a hotkeys script in init.d and I have now installed
 the corresponding debian package for that and all is well.

Many thanks for your help, funny how fast one can forget sometimes..
Strange though that I did not have any issues with 2.6.28, 2.6.29 (not
that I can remember at least).

/Andreas
