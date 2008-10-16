Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYJPIV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYJPIV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 04:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYJPIVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 04:21:47 -0400
Received: from main.gmane.org ([80.91.229.2]:54339 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbYJPIVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 04:21:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Thu, 16 Oct 2008 08:21:35 +0000 (UTC)
Message-ID: <loom.20081016T075618-911@post.gmane.org>
References: <20081016002509.GA25868@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.166.207.29 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg <at> kroah.com> writes:

> 
> Hi,
> 
> You brought this topic up a few months ago, and passed it off as
> something we would discuss at the kernel summit.  But that never
> happened, so I figured I'd bring it up again here.
> 
> So, as someone who constantly is dealing with kernel version numbers all
> the time with the -stable trees, our current numbering scheme is a pain
> a times.  How about this proposal instead?
> 
> We number the kernel based on the year, and the numbers of releases we
> have done this year:
> 	YEAR.NUMBER.MINOR_RELEASE
> 

I strongly disagree about the full year indication in front ;) 

and bring up my older idea of

the scheme to be s.yy.ww.tt, that is :

s - series, as it is now (freedom to Linus to declare a whole 'new generation'

;) if he wanted  )

yy - two (in a hundred years, three) digits of the year

Now the interesting part begins which is

ww - the number of the week of the release. This will be between 1 and 52 (53)

tt - the number of the week of stable release. As above.

It is:
- most similar to the scheme used so far,
- informative : the ww and tt numbers are the week numbers of when the actual

release HAPPENED, not when it is predicted.

- easy to put some automation into it (git release HEAD now ) could branch the

current and rename it accordingly (not that I know how to do it, just

imagination)

- (mod) in case there are more than one release in a week, letters could be 

used (e.g. 2.08.44[a..z]) in as many count as needed (2.08.45deadbeef.50sodead 
)(or put the git commit indication there ?)

- in case the stable releases go forth into next year or over, the stable team

puts additional .yy.ww instead of their own .tt (like 2.08.45.09.05) (yes I know

it is long)

- the -rc releases go as usual beginning with latest mainline release

(2.08.45-rcX, X being a number as it is now)

- dubbing behavior of silicon manufacturers who print the actual week number of

production onto their chips - imagine looking at a chip and quick glancing at

the kernel version number and _knowing_ it should be OK ;)


My £0.02 ;)
> 
> Any thoughts?
> 
> Let the bike-shedding begin!
> 
> thanks,
> 
> greg k-h
> 

Lukasz


