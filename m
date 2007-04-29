Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbXD2HOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbXD2HOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXD2HOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:14:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:64873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbXD2HOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VAi2qEu54kbHYV1DllgWkjtQWgciLeHRZ72c+8q55QB4Mb5tmRf6BHzRN890zVuXqZiQmjKcOHrw8uIkrE0Zcse50rmnloxBwrupi6/81axMRYWiguNCpLGeKSfnFeSvuMKpnhf508Mn34O0wIXWqhpTv8wXB8cbXpwe6udTBrg=
Message-ID: <5a4c581d0704290014p1ee107a7jb4c6737f51ef8bb8@mail.gmail.com>
Date: Sun, 29 Apr 2007 09:14:35 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [2.6.21-git2] sk_buff changes break Cisco VPN client
Cc: rdreier@cisco.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070428.202405.14973612.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
	 <ada647gmcq0.fsf@cisco.com>
	 <20070428.202405.14973612.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, David Miller <davem@davemloft.net> wrote:
> From: Roland Dreier <rdreier@cisco.com>
> Date: Sat, 28 Apr 2007 14:05:27 -0700
>
> > However I can suggest vpnc (http://www.unix-ag.uni-kl.de/~massar/vpnc/)
> > as an alternative.  I'm not forced to use Cisco VPN access any more,
> > but when I tried it, vpnc was tons better than the Cisco product.
>
> Also, and I know this might be a COMPLETE SHOCK to some people, but we
> do have a full in-kernel IPSEC stack and using it with openswan to
> connect to VPNs works perfectly fine.
>
> I use it every day.
>
> It's quite amusing that people use a userland IPSEC implementation
> via VPNC, in spite of this.
>

Have a look here

https://lists.dulug.duke.edu/pipermail/dulug/2007-March/010792.html

 where someone seems to be in my same boat. No, openswan/IPSEC
 does not work in all configurations with Cisco VPN concentrators -
 and by Murphy's law, I'm in the non-working configuration.

Hope this clarifies the reason I asked. And if anyone out there
 is in doubt about it, I absolutely hate having to rebuild an out
 of kernel module every time I build a kernel, crossing fingers
 it doesn't break (again). I would use *anything* else.

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
