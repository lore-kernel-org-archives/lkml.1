Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZDWTDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZDWTDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZDWTCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:02:52 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:40643 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751905AbZDWTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:02:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nPPXDny0ZukEviDZ0o1UaS4I6hW5MiymfITbNm3b1FFWYgN1IwxX5rjGiNVZF+1m/57Pjm/1egC8uBnIv2Cg/sydBa+Ks/r8BMnzCbOHSUdZLpxfgPrI9fi67ZBo7JeCzXDpoe6AnLIXGR1MmwY+TZPxT58PpbGIIcSjFxGmncg=  ;
X-YMail-OSG: CsImVckVM1mM7rPot5IOUj9ok_kjUdw0Vmd04e78NHgox6EqciuIR7UWukPdHUiaxpeqK5G3UeV9pcSQxShEvwT1kMLoHgEpbNSVnMugedCjWNmiuat4NSLK4oxkWIitJBWeDDZiksZHCAOPZbWqO70IW7CiexEfcCs1QNAGF3j3_s9GXBFa91qetmWvlvq94FQbPOfO3rd4dFf_ICXRHH6DdIjsxCyKfjoMAFGNhxwKFyNS6LnppJ4jlQT_g_pOr.U3bK1QpbZslRX4
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Thu, 23 Apr 2009 12:02:48 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it> <200904231115.57525.david-b@pacbell.net> <20090423202749.767ab73b@i1501.lan.towertech.it>
In-Reply-To: <20090423202749.767ab73b@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904231202.49465.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Alessandro Zummo wrote:
>  But first I need someone to validate the theory that
>  says that we don't really need the IRQs to be disabled,
>  as I stated in the email to Andrew.
> 
>  do you agree? :)

If (rtc_update_irq() starts disabling them locally,
	&& its interface stops requiring callers to do that)
then
	it's fine;

