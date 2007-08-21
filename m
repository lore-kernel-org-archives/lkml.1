Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbXHUBmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbXHUBmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 21:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXHUBlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 21:41:55 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:23083 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754315AbXHUBly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 21:41:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GmRx3eo4SMyFG/TrXscB5fbeISMVtu8jkz1ToT0ZHy6W1kyMaMbylf47wl2hCq8q9/X0Nz1SSYBCMvjFCsLuk/8K3IaJPq4wvumeKhrUiAvTlJ7nh3OKScTKcSl1oaBiu2WUE9sIMjWhKH2T1gryODrEs+rE03wjwr5bqpF0dYc=  ;
X-YMail-OSG: 0z2VC_cVM1ndrXgg1s6CZ3MUo3mx2uZw1ibf4PlFIbVuAJma8ouE_N70c01sJI9xco61zfGIBojh3GeqD13YhYet7aDaN7OXzJvlo4Dk.6vWV7pqPUAINQqXzdIAQ8F9CmYSEjtRcyF8sA--
From: David Brownell <david-b@pacbell.net>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Date: Mon, 20 Aug 2007 18:41:51 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
References: <46C098FD.1030601@googlemail.com> <46C09C11.3070105@googlemail.com>
In-Reply-To: <46C09C11.3070105@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708201841.51366.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007, Michal Piotrowski wrote:
> Subject         : EHCI Regression in 2.6.23-rc2
> References      : http://lkml.org/lkml/2007/8/10/81
> Last known good : ?
> Submitter       : Daniel Exner <dex@dragonslave.de>
> Caused-By       : Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
>                   commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
> Handled-By      : ?
> Status          : unknown

Fixed I believe by Stuart's patch:

http://marc.info/?l=linux-usb-devel&m=118765934722610&w=2

