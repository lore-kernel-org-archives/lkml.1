Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYCHWu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYCHWu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 17:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYCHWuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 17:50:51 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34224 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751523AbYCHWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 17:50:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UbX7IQWoRgkJXFgI6jw94k47JsS8GlmamCLBdT3XitM68Tc8Sqy01EF2fC/LHjAgq8nwm2E+8XEgaj959s04bCk6CCYsHCWhrprp7AwS5JCxKdF+lqdAFaz032esLWGzbKVCQTPpLWhUfKgIF8SWGKF3Cb/Mp7IKBuplH6NH5VE=  ;
X-YMail-OSG: ILuf8boVM1nN1XkeZZKhkCJyyz_ULNEWTsdwy0cho3THJP_TjQ99e7ITR8Zsk31koCksolCR_w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: WARN_ON(): proc_dir_entry 'rtc' already registered
Date: Sat, 8 Mar 2008 14:50:48 -0800
User-Agent: KMail/1.9.6
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20080212132626.GA1534@elf.ucw.cz> <200802180308.17115.david-b@pacbell.net> <20080219101246.GB2202@elf.ucw.cz>
In-Reply-To: <20080219101246.GB2202@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803081450.48579.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Pavel Machek wrote:
> On Mon 2008-02-18 03:08:16, David Brownell wrote:
> > On Monday 18 February 2008, Pavel Machek wrote:
> > > > How to fix ... how about:  instead of just warning folk
> > > > off such legacy RTC drivers [1] we just wrap them with
> > > > an "if RTC_LIB != n" so this mistake won't be possible.
> > > 
> > > Yes, disabling bad configs in Kconfig seems like way to go.
> > 
> > Problem is ... that also disables valid configs that
> > get assembled by picking the right module(s) for the
> > target system.
> 
> Is there any reason to use the old rtc subsystem?
> 
> At least OLD_RTC=y NEW_RTC=y should be disabled... even if OLD_RTC=m
> NEW_RTC=m makes some sense.

The patch I sent earlier today makes the two mutually exclusive.

Note by the way that there is no OLD_RTC analogue ... just a bunch
of individual drivers.

