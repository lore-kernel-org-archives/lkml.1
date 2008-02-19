Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYBSTNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYBSTNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYBSTNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:13:01 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:38722 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754029AbYBSTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:13:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CordKNQd7zhrRfHlqtaKNSjm83I3XNX/IJ1OJqLaCHMan8BI8/MDf15I3enKNMowuZlC6IXHFm2JPX42Xb3xaArTIIPbxTXQLcG5zTodsB9d/Ch8liN4MU8c8DDSsLZmbdm4XQYquYDfvAi2s4gHfyquMgKE3xDO7JB0BfmiWSI=  ;
X-YMail-OSG: 8BF36xAVM1n.OHxKpLvMy2D_g75kmOfMewuYcagJKkMsfYO.Ht9UsDN90PhANWi.eDK5zo7O8Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] suspend/resume self-test
Date: Tue, 19 Feb 2008 11:12:57 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080219101116.GA2202@elf.ucw.cz> <20080219144328.GD21176@elte.hu>
In-Reply-To: <20080219144328.GD21176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802191112.57616.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Ingo Molnar wrote:
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > Thing is, this will catch not just regressions ... but cases where 
> > > STR never worked in the first place.  Video problems, etc.  Also 
> > > various system startup races, as in the PCMCIA and MMC/SD/SDIO cases 
> > > I noted.
> > 
> > David is right here. At minimum, s2ram needs acpi_sleep=... options to 
> > tell it how to set up the video. That is not issue for you, but it 
> > means we should not be doing it by default.
> 
> nowhere did i suggest that it should be default-enabled ...

The patch you asked to be merged *DID* have it be default-enabled!
So you did more than just "suggest"... if that option is enabled in
Kconfig, this test is always forced on and it will cause failures
on systems where STR has never worked.

The patch comments even pointed out that flaw.
