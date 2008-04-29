Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYD2Kko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYD2Kko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761050AbYD2KkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:40:20 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40250 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759759AbYD2KkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:40:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=U+Mxpz5YpNfAgH5j7/Hy6NhTcLiPZfPb48IQoXmhxNIV2zWvTBZIA0KHJfIX4QKlQx/GvAuddR3RAS1qz9rCocx2GtWzCVCVQoBpYvmY9FfvQQm3Rd9TJxcMO0oXWBdNYgJHq11fzFRrzaQLWliR1B/FQprNC5lz6p1ygdWfGGA=  ;
X-YMail-OSG: Jy6md.gVM1kgw8ymIw65k8h6nuw.wslOb4lQc3yQTG2QomnWdnaT.UDrik2v5duiKGgULLpsH40IaSb2ZlBoL21ed4RBMhLBIDPpGlvLIg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: rtc_valid_tm doesn't check tm_wday
Date: Tue, 29 Apr 2008 03:40:16 -0700
User-Agent: KMail/1.9.6
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
References: <20080429064408.GA8352@digi.com>
In-Reply-To: <20080429064408.GA8352@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804290340.16642.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Uwe Kleine-König wrote:
> Hello,
> 
> I'm currently writing an rtc driver and want to use rtc_valid_tm to
> assert to have a valid date before writing it to the rtc.
> 
> Now I wonder why rtc_valid_tm doesn't check tm_wday for being in the
> range [0 .. 6].  Is there a reason?

As far as I know, the kernel doesn't use tm_wday, tm_yday, or
tm_isdst ... so none of those fields are expected to be valid.
See the rtc(4) manpage.

- Dave
