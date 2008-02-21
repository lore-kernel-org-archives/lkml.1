Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbYBUBdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbYBUBdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYBUBdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:33:12 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23139 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755205AbYBUBdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:33:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PD9qCwpW1dYacpJz78pQGBcTC/5WLG+IRruejr+g04fq5NWBAbrQIt3ur1xlf3rk572O5bHW01kuCpkMfuCjnqC0B10kCSWvfBQUQX1MyRzJLdHHFOvuNXYNL/PpDPgfNV4bVrTOJKolQ01Oc2G2KhkABrET7PLIRORxcjD4X8U=  ;
X-YMail-OSG: NlrVzMcVM1mzg2u56zZUpBG0objQthiKyShcQYnP_UWemCRCm1KVrOtcQi165.19uZMxegYu4w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: atmel_spi clock polarity
Date: Wed, 20 Feb 2008 17:32:38 -0800
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com> <20080220.142109.11595419.nemoto@toshiba-tops.co.jp> <20080220103446.1621c81f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080220103446.1621c81f@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802201732.38932.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Haavard Skinnemoen wrote:
> > 
> > Unfortunately it did not work.  The clock state did not change by
> > writing MR register.
> 
> Ok, thanks for testing.
> 
> In that case, I think the best fix is to let NPCS0 stay selected
> permanently in MR and overwrite CSR0 with to the new slave's settings
> before asserting CS. But that's a more complicated change, and I don't
> know how it will affect the AT91RM9200 special cases.

The rm9200 special cases which, ISTR, still don't work right ...


> So I suggest we merge your patch for 2.6.25, and try to optimize it
> for 2.6.26.
> 
> David, do you want me to pass on the patch with my signoff or just ask
> Andrew to add my Acked-by to the patch already in mm?

It'd be good to let Andrew have your ack.  It's already in MM, so
if I don't need to sign off it's nice to have less to do there.  :)

- Dave

 


