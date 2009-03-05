Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZCEBiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZCEBiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZCEBiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:38:12 -0500
Received: from n11b.bullet.mail.mud.yahoo.com ([209.191.125.178]:22970 "HELO
	n11b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750761AbZCEBiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:38:11 -0500
X-Yahoo-Newman-Id: 595037.91259.bm@omp405.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qW9pw6JqIOGHyaHp8mb3JlvE57JnQ+FD1S4eaIvaGc/wgQdIYPDFDLykIGbpuSVTrYzqLYWepA3sXUAyYlN42RIARhL01qEJV9RFunMmucNoHFDLAWpFWXZz/itABP4+/gyvqmXAWySQAKBOhvHDFjc5Ve8yK22yK/JVgf5/NnA=  ;
X-YMail-OSG: CxX6f2AVM1mR.dh3UOWNO1W1WooCKaH7_A4a6laVpPyAhFsRDXOtiXBenyAsUnvRPzDRnx4w0qIhIC7tkorcfZ30a_IiHUFMB0RxXcj2evpCGE3kNZj0HqZUxBXK1ZxlohybnxEEdpZF6DRPAQdMa4TvNKd.Ge6udS3F6nbLlE_6bPz.kjiLNfuNbgXY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com, ext Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Date: Wed, 4 Mar 2009 17:38:07 -0800
User-Agent: KMail/1.9.10
Cc: Felipe Balbi <me@felipebalbi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@openedhand.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090304090026.GC7394@dtor-d630.eng.vmware.com> <20090304101231.GS4640@scadufax.research.nokia.com>
In-Reply-To: <20090304101231.GS4640@scadufax.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041738.07659.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Felipe Balbi wrote:
> 
> > Cool, I will keep it in my tree pending the threaded IRQ issue
> > resolution.
> 
> I guess the threaded IRQ issue will still take a while to be solved and
> this driver is working as is, so there's no big problem in pushing it
> and fixing the threaded irq on later patches. But I'd like to hear from
> Andrew, Dave and the others about that.

I'd say just push this driver with the other 2.6.30 stuff.
There's no point in holding it back.

The yet-to-be-merged threaded IRQ support won't break the
in-tree stuff.  And it's not exactly fully cooked, since
it doesn't yet handle a highly-relevant use-case ... :)

So the plan of record remains unchanged:  once mainline
has adequately functional threaded IRQ support, update
twl4030-family drivers to use it.  Meanwhile, use the
current stuff, which despite some aesthetic warts still
works just fine.

The positive note seems to be that the IRQ threading
patches have gotten refreshed.

- Dave


