Return-Path: <linux-kernel-owner+w=401wt.eu-S1765421AbXHXSZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765421AbXHXSZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbXHXSZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:25:06 -0400
Received: from smtp124.sbc.mail.re3.yahoo.com ([66.196.96.97]:46592 "HELO
	smtp124.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758369AbXHXSZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:25:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=fvufdrQxv0o3VJH7Hf6uEf7lbPRZch0sJxp/LPO72keXHk8YPulDIevRaNR9ATg+TsEm9hwp4g0aUED5Vlz7EB0FkWQocXidNla1YxX+u9Ar+LA5Lh6y6Ev74vbqKfaHND0/vvkBqokSKXNPHVFi/XaOO2IrHKt6m7MrqgMZ0B8=  ;
X-YMail-OSG: xsZqijQVM1mZxhEV9Sy84uh_1HfKw91oBatyZYln6TN_ByTpJgaHdiv_FD_y34JIDaXIajI0QIpd_ZnwUQbGGrkPi5s1ugV5cCuDTAKhGq_eXUuZccY-
Date: Fri, 24 Aug 2007 11:25:01 -0700
From: David Brownell <david-b@pacbell.net>
To: stern@rowland.harvard.edu, oliver@neukum.org,
       michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions v3
Cc: linux-usb-devel@lists.sourceforge.net
References: <46CF0DEF.5040107@googlemail.com>
 <46CF17A0.2060503@googlemail.com> <20070824175608.GA5333@suse.de>
 <20070824180120.GA13916@dose.home.local>
 <20070824180833.GA14415@suse.de>
In-Reply-To: <20070824180833.GA14415@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070824182501.4A1C1236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Subject         : 2.6.23-rc1: USB hard disk broken
> > > > References      : http://lkml.org/lkml/2007/7/25/62
> > > > Last known good : ?
> > > > Submitter       : Tino Keitel <tino.keitel@gmx.de>
> > > > Caused-By       : ?
> > > > Handled-By      : Oliver Neukum <oliver@neukum.org>
> > > > Status          : unknown
> > > 
> > > Last I heard was that Tino was going to try to do further testing, but
> > > as he hasn't responded in a few weeks, I'd mark this one down to,
> > > "unknown and unreproducable".  Unless someone else knows more?
> > 
> > I was at least able to reproduce it with 2.6.23-rc2. And I tried it
> > hard with 2.6.22 but it didn't happen.
>
> Ick, I didn't realize this.
>
> Oliver and Alan, any follow-up on this that I need to look into?

Try with the latest kernel from GIT; maybe that cpufreq thing
(since reverted) was a factor.
