Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXKODyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXKODyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 22:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXKODyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 22:54:37 -0500
Received: from pool-71-247-7-55.nycmny.east.verizon.net ([71.247.7.55]:57707
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755127AbXKODyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 22:54:36 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 22:54:35 EST
Message-ID: <473BC168.4000206@gatworks.com>
Date: Wed, 14 Nov 2007 22:47:52 -0500
From: "U. George" <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux on Alpha processors <axp-list@redhat.com>
CC: linux-kernel@vger.kernel.org, Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: Question about F_RDLCK and F_WRLCK on alpha
References: <473B600E.9030703@linux-kernel.at>
In-Reply-To: <473B600E.9030703@linux-kernel.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I suppose this can be better analyzed if the cpp output is presented to 
show exactly how rdlck/wrlck is included/defined .

But the only requirement is that the flags are unique. solong as wrlck 
!= rdlck != unlck every is happy.

There is no expectation that an i386 binary will run on an alpha machine.

there might be an issue if the i386 source code uses "0" or "1" 
constants instead of the WRLCK/RDLCK. And then compiled on the alpha. 
Then it would be out of sync.

I suppose they are different bec the folks at OSF had it defined that 
way. And there was some need to run OSF/alpha bins on a linux/alpha ( 
just a guess on my part )

Oliver Falk wrote:
> Hi!
> 
> Can someone explain me, why we have different define's for WRLCK and
> RDLCK within alpha kernel headers:
