Return-Path: <linux-kernel-owner+w=401wt.eu-S933123AbZDBUMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbZDBUMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbZDBUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:12:13 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64428 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbZDBUMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=mNA/LammsJy2eoeTCGz/7FAAr4WWLCI5kenCrC/J3t7KALmqRruKksL+qhAip5PYWE
         Dew0kxLySrbOFvfhCjB/WCBQHzLQRdIsHgmKQsJ6RCowE7KVjKCZl4JRG2ABps0lrvND
         4Pn2rpCri/YzElLEyi68aDpVqQeVvKFwP0H0Q=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Date: Thu, 2 Apr 2009 22:12:05 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rc1; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200904011155.20751.a.miskiewicz@gmail.com> <20090401210054.GS18394@sequoia.sous-sol.org>
In-Reply-To: <20090401210054.GS18394@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200904022212.06118.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 of April 2009, Chris Wright wrote:
> * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > and this as bad commit:
> >
> > 7f7ace0cda64c99599c23785f8979a072e118058 is first bad commit
>
> Does it make any difference if you roll fwd a couple commits to:
>
> 802bf931f2688ad125b73db597ce63cc842fb27a
>
> That fixes a possible problem with the cpumask change and interrupt
> migration.

Will test.

>
> And to be clear, one commit earlier works?
>
> fae3e7fba4c664b3a15f2cf15ac439e8d754afc2

Sort of, I got werid things with this commit... after initial suspend and 
resume it started suspending and resuming in a loop without need for any 
intervention  on my part (so I didn't have to touch for it to start resuming). 
... but if it resumed and I started using keyboard it stopped suspending.

32b838b8cfa269d688889b3213e7ee37ee901f72 behaves the same way.

Any ranges or commits to test/bisect?

> thanks,
> -chris

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/


