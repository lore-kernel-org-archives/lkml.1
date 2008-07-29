Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYG2UIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYG2UIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYG2UIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:08:40 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:27849 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751906AbYG2UIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:08:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nQ75WpprWo6RHtZROEq4hs+8Si2M9rhNaoVIvNTuIneHYcBe1dja2iJ+aHe/6SIE/xOovqSR22zrc2bUokm1YwlA4DVZmVJZTyZViisy0lqzBZ55b1sdhoaSsYhhp8wj5ynOSyg6s8uvXjU9q/j1RZrpKUEPZhgOWupwpbhAoi4=  ;
X-YMail-OSG: qRD8fdgVM1n2_3swOUtya1PeSOVDUUF15H9b6pWPKhQHGPX9KraAdVbedtU9CFovRXzmIe1x2ONNaHSD.fL4f_wYLP2Qk.gmEspqmYV7VQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: =?utf-8?q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Date: Tue, 29 Jul 2008 13:08:38 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20080726154617.GA5613@notes.lisk.in> <200807281505.37122.david-b@pacbell.net> <20080728233638.GA10327@nomi.cz>
In-Reply-To: <20080728233638.GA10327@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807291308.38134.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Tomáš Janoušek wrote:
> Hello,
> 
> On Mon, Jul 28, 2008 at 03:05:36PM -0700, David Brownell wrote:
> > Surely you agree that having the framework shut down only *emulated*
> > update IRQs, not "real" ones, is inconsistent?  And hence undesirable?
> 
> The idea was that if the "real" ones get turned on using some ioctl magic the
> framework has no exact control over, they shouldn't be shut down by it. But
> yeah, your point of view looks fine as well.

The /dev/rtcN support *is* part of the framework.  ;)


> So I guess I'll post the current patch to Andrew and then, someone (not me,
> for time and competence reasons, sorry) can prepare a patch removing the
> release op and changing the calls in framework's release to call
> rtc_dev_ioctl.
> 
> Is this ok?

Yep.

- Dave
