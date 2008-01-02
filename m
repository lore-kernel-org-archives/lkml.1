Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYABTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYABTOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYABTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:14:16 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:45756 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752685AbYABTOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:14:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ObHwnErbXGO4wYD/EHOw1AU/R9GGt93MpyPliNtTxQheQNvoJtCufxPAXEsjFgjldqiOZy1XAf4j5i2Oe8/NNcTWj7yUNzC7oh7CEF6r4yW4A8iitdf1okbhg+RFVSsnKusAJW39zLxMILK/82L9FFQsU5Ik4CrKzMz0Y2qiVyY=  ;
X-YMail-OSG: c.JD3SsVM1lVxqrV4lgtefTxPZilnt9N1b10M7.pZr6rE5L75LLoR9UGeLmHpacavLWPRin0ZQ--
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net, me@felipebalbi.com
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB	options normally reserved for OTG
Date: Wed, 2 Jan 2008 11:14:10 -0800
User-Agent: KMail/1.9.6
Cc: gregkh@suse.de, Robin Getz <rgetz@blackfin.uclinux.org>,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801021047.16036.david-b@pacbell.net> <20080102185745.GA17890@kedavra.cpe.vivax.com.br>
In-Reply-To: <20080102185745.GA17890@kedavra.cpe.vivax.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021114.11074.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Felipe Balbi wrote:
> 	 The problem I see here is that my only
> "user" is musb driver, currently only available on linux-omap git tree.
> 
> Maybe it's time to send it to mainline, what do you think Dave?

Probably time, yes.  ISTR the main open issues are on host side
behavior, and it'll be easier to sort those out if musb_hdrc can
be updated without a few months intervening lag time.

Plus that'll make it easier to merge the Blackfin platform updates
for that driver.  It's fine that musb_hdrc works on N800, N810,
DaVinci, OMAP2430, and more ... but non-TI chips also integrate
that high speed OTG silicon.  :)

- Dave

