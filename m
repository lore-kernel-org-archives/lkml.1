Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYJPS0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYJPS0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYJPS0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:26:16 -0400
Received: from willie.n0ano.com ([64.66.241.76]:57554 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753243AbYJPS0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:26:16 -0400
From: n0ano@n0ano.com
Date: Thu, 16 Oct 2008 12:25:56 -0600
To: Yinghai Lu <yinghai@kernel.org>
Cc: n0ano@n0ano.com, Paul Bolle <pebolle@tiscali.nl>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081016182556.GE14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com> <20081014233031.GB14490@xolotl.n0ano.com> <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org> <20081016171218.GD14490@xolotl.n0ano.com> <48F785B0.7000008@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F785B0.7000008@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:19:28AM -0700, Yinghai Lu wrote:
>... 
>                 if ((p->early && strcmp(param, p->str) == 0) ||
>                     (strcmp(param, "console") == 0 &&          
>                      strcmp(p->str, "earlycon") == 0)
>...
> we need that holder in console sections to compare with console and earlycon.
> 

I have no problem with keeping the code associated with early
prints, as you say we need that holder.  I'm saying the `console'
parameter serves this purpose, we only need to remove the `earlycon'
portion of that if statement.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
