Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYAEWLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYAEWLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 17:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYAEWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 17:10:42 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:34453 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757329AbYAEWKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 17:10:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZB3LbqzTJ3nKR7eI+SQNhZLTBDn0+oZ8gfjnDpR2lSRT+ehfMWBReWU78vfR90S9jWgq3ld1VF05FzQbeoUqZyaYAlECF06+JvwCe+dTOdC+lsQp2c+ZTbByQi27gZSlYvn7E8mjCCunTeK8JlcJHXKPJz4HzxuvZkTZy6pdAKA=  ;
X-YMail-OSG: cEZhkZoVM1ny9gpfvTevX.RdQEeF3BZ4H0lvriQlYxNhmIbYxqVeriWZdEXTxL0sMmBEBi.UWw--
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [patch 2.6.24-rc6-mm 4/9] gpiolib: avr32 at32ap platform support
Date: Sat, 5 Jan 2008 14:09:57 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200712281927.32575.david-b@pacbell.net> <200801051210.56567.david-b@pacbell.net> <20080105214916.7c67a522@siona>
In-Reply-To: <20080105214916.7c67a522@siona>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801051409.57711.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2008, Haavard Skinnemoen wrote:
> On Sat, 5 Jan 2008 12:10:56 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Teach AVR32 to use the "GPIO Library" when exposing its GPIOs, so that
> > signals on external chips (like GPIO expanders) can easily be used.
> > 
> > This mostly reorganizes some existing logic ...
> 
> Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Thanks ... an ack is better than that informal "OK".  ;)


> I'm not going to merge it since the rest of gpiolib isn't in mainline
> yet.

Right.  That's why the PXA support is going through Andrew too.

