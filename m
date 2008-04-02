Return-Path: <linux-kernel-owner+w=401wt.eu-S1761799AbYDBUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799AbYDBUnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761857AbYDBUbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:31:15 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23219 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762501AbYDBUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:31:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rVsO9/gsGYS9DNReI0DTFZr89YHm2b5QZB5D/2FZenqfOsbt/n90izlUirzsI2KZqhf8xMgy30l2JC1EUz/IopGjgaufyVRrOFdKx1daJ7RNbRSvC1gJfRn5DeIWD0spsY4wVflZfrctdBgawVyZuHw8/tug5zyPepGEKqqPxVw=  ;
X-YMail-OSG: 1U1nH9EVM1lEj_N9EJrDoUPv3dgdpkvaOvNxoawGJF6J8jJif_zSml7r6piy2dEOJlBYkn1cRQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7:  Ugh.
Date: Wed, 2 Apr 2008 13:22:05 -0700
User-Agent: KMail/1.9.6
Cc: stern@rowland.harvard.edu, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org> <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <47F3AFD5.9080801@rtr.ca>
In-Reply-To: <47F3AFD5.9080801@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804021322.06002.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Mark Lord wrote:
> 
> > And try the change I suggested there:  taking the
> > HC_IS_RUNNING test out of ehci_iaa_watchdog().
> ..
> 
> Will do, thanks.  And there's a similar one in ehci_work().  ??

Don't see why that should matter.  In any case, that
test hasn't changed recently.

