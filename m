Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYIXUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYIXUtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYIXUsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:48:07 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37570 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755007AbYIXUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:48:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ya4H47k6mU56aM9c3Q+wjyzC/uPTDK+ve8ID7jlTvwAa47ZKZhIb96fJszAukYNk3r0S+cJcQgkaiilcIY5yGE+SbRocUGT99Ojb/drnaJhu+WeaitwM7A16uIPiwugopfukZwPMw1VLvKQdE1ffwPChoCnr4Z2Ku2Bp0bWpwt0=  ;
X-YMail-OSG: 4J5sq.4VM1mfQ90u2V6DO1NEGgEwjoRH_3Im9t.R14bSSbOwod8BufP0sp39ozlDmVhNtgNQ0OG74vyPhYpQBZEXlw.I_7cUSLZLlLMj66z3iK6z0YCaR1WPenQ3krWptIg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: joakim.tjernlund@transmode.se
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controllerdriver
Date: Wed, 24 Sep 2008 13:28:34 -0700
User-Agent: KMail/1.9.9
Cc: Li Yang-R58472 <LeoLi@freescale.com>, avorontsov@ru.mvista.com,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org
References: <1219916613-28827-1-git-send-email-leoli@freescale.com> <0C69E0CDED15E4469A445DE244C1B9F708CEE6@zch01exm26.fsl.freescale.net> <1220343329.7762.23.camel@gentoo-jocke.transmode.se>
In-Reply-To: <1220343329.7762.23.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809241328.35008.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008, Joakim Tjernlund wrote:
> 
> > Noted:  AFAIK, RNDIS gadget in Linux doesn't interoperate with windows
> > well enough to be production level.  Use at your own risk.
> 
> I see. If one wants to connect with CDC to Windows, what drivers are
> there for Windows that works well with Linux?

I believe MCCI has some.  It also has drivers for a CDC subset,
pretty much the same one Linux has used forever except wrapped
with a few extra descriptors to make it practical to identify
that "SAFE" (!) subset without needing vendor and product IDs.

- Dave

