Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZA0SgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZA0SgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZA0Sfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:35:53 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2271 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZA0Sfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:35:53 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Tue, 27 Jan 2009 10:35:33 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Tarkan Erimer" <tarkan.erimer@turknet.net.tr>
cc: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "David Miller" <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
Message-ID: <20090127183533.GA10466@xw6200.broadcom.net>
References: <49771D65.3090205@turknet.net.tr>
 <20090121152818.GA3438@x200.localdomain>
 <497870A3.4070200@turknet.net.tr>
 <3f9a31f40901262230s3efb9242jcd4a02ee84944daa@mail.gmail.com>
 <497EBBB1.5020609@turknet.net.tr> <497F2CDC.6050106@turknet.net.tr>
MIME-Version: 1.0
In-Reply-To: <497F2CDC.6050106@turknet.net.tr>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 65618C733FC42433269-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:48:44AM -0800, Tarkan Erimer wrote:
> Tarkan Erimer wrote:
> > Jaswinder Singh Rajput wrote:
> >> Is this ubuntu's specific problem or you also getting these
> >> warnings/errors on another releases.
> >>
> >>   
> > Yes,it's specific to Ubuntu's kernel build process (make-kpkg). I had 
> > no time to try with regular kernel build process. But; if it's 
> > necessary, I can try it out. BTW, my box is Kubuntu 8.10 with latest 
> > updates.
> >
> Now, I tried with 2.6.29-rc2-git2 and the result is same. No difference. 
> When I have time, I'll try via regular kernel compile process to see 
> what will be happen.

Like I outlined in my previous email, this is a scripting / tools problem.
Updating your kernel will not help.  Either the script or modinfo needs to
be modified to somehow recognize that while the driver does make
request_firmware() calls, the firmware resides in the kernel itself.

> PS: If you write a reply to "netdev@vger.kernel.org", it will not reach 
> to me. Because, I'm not subscribed to this mailing-list. So, please CC 
> it to me.
> 
> Tarkan ERIMER
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

