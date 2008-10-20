Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYJTEmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYJTEmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYJTEmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:42:06 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:34149 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003AbYJTEmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:42:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Rj4zIqUwnBiOPLknJ7jZQKUolAGKdphhc7zMWmkYD/j9xvPgF8neqY6VBF0HChvPqIet/5yb+7OrcDuiUpFqiekY8HPMlaLP2WSbxpqRh1wscXhMdF6Lhe88XxeUsB964XJ7/SaCRT45TBcqXjMMj0umRt+qm4W/rXC4spxv8k4=  ;
X-YMail-OSG: iXkM3bEVM1lvUe27pih5dJ6AsUxNF4Ak5DnW439kiNO7sy7Zo.kXsq50lpMGRlKl3FPvUh726Oa1suV3ugGnB__4aNVLV8gyrqErnW7.whEsJN779_zszi.J9kbujUwYu0kQjy5LJlrxkY9mnZmCzgiPn1S2he0LKBCUX4o-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Date: Sun, 19 Oct 2008 21:16:51 -0700
User-Agent: KMail/1.9.10
Cc: "Piotr Skamruk" <piotr.skamruk@gmail.com>, "Michael Buesch" <mb@bu3sch.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200807202146.12759.mb@bu3sch.de> <200810181354.23955.david-b@pacbell.net> <aec7e5c30810191944u4c125943h895099b3f1eaa813@mail.gmail.com>
In-Reply-To: <aec7e5c30810191944u4c125943h895099b3f1eaa813@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810192116.52286.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 October 2008, Magnus Damm wrote:
> >
> > I fully support the idea of SPI over GPIO.  It's just that
> > particular patch which is problematic.
> 
> Ok, let's fix those issues then!

The issues I identified earlier still haven't been resolved...
one of several reasons IMO to just use a different driver.


> > I'm sanity testing a refresh of the *original* late-2006
> > SPI-over-GPIO driver.  It's actually usable as a drop-in
> > replacement for a "native" driver.
> 
> The Openwrt driver by Michael Buesch works just fine for me, but if
> you prefer to switch driver that's of course ok too.
> 
> > Unfortunately I goofed and pulled down the current GIT tree
> > and found lots of unrelated breakage (non-SPI) that's keept
> > that sanity test from proceeding apace.  And the board on
> > which it's most recently been used is currently broken.
> > I may just send that patch out soon, as an FYI...
> 
> Please CC me and I'll test it on some SuperH boards. Thanks!

Patch follows in a separate message, with trimmed CC list.

- Dave


