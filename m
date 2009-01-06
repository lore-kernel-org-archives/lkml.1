Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZAFFln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZAFFln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZAFFlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:41:35 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:45832 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750762AbZAFFle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:41:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6HhpiweOpq1uS6p8rwU0UkmlM5h9mB+IIJ3lwwM7Q5e2XwETvUIj+YRm65X8efWKF7PWiphlNdPCXlLay43ZfCtjBum2RcmB/28HQrbwgDIM08aVNNFolBjxcfGazEQZ9zjHL47Ycjouawinz6qjJZ+YeVKfAIbPKIkQAgs8iEQ=  ;
X-YMail-OSG: U2XxM5MVM1lRZ9MnBB0gkN..bBz0G3Dn0J9krxkHHN5Xtdpwkav.7mOkJPuDFDgRKAetVsoMNnH5S_Rp7eHlAn39yayj_HGIzm3cwQ5EwM2HVxtnE04CYqYBiEMXWEvZiQr9qQV8H1J2l5kcXOswQQWD8Jm05Awo6jC9U3lqw9G1nxLaOPAKLBSNIULEPZDUDSkoXKbmC99EgILj1Uq4oNX4mA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.29 -mm merge plans
Date: Tue, 6 Jan 2009 16:41:14 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com> <3584.1231219651@turing-police.cc.vt.edu>
In-Reply-To: <3584.1231219651@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061641.15066.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 16:27:31 Valdis.Kletnieks@vt.edu wrote:
> On Mon, 05 Jan 2009 18:00:33 +0900, KOSAKI Motohiro said:
> > > #
> > > page_fault-retry-with-nopage_retry.patch
> > > page_fault-retry-with-nopage_retry-fix.patch
> > > page_fault-retry-with-nopage_retry-fix-fix.patch
> >
> > I oppose this.
> >
> > Valdis.Kletnieks@vt.edu reported this patch has bug in
> > "28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
> > thread.
> >
> > Nobody answer his question yet.
>
> It's still present in -mmotm0105.  I'm open to suggestions and any
> debugging/instrumentation patches you might suggest - I'm completely at a
> loss as to how the patch manages to mess up xmms the way it does.

It's pretty soon for such a patch to go in too, IMO, even if there wasn't
a known problem with it. 

