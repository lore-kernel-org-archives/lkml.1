Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYHLAiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYHLAiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYHLAio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:38:44 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:33444 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbYHLAin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:38:43 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Tue, 12 Aug 2008 02:38:40 +0200
User-Agent: KMail/1.9.9
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080810030521.GA2332@gondor.apana.org.au> <20080811190131.GL13158@linux-os.sc.intel.com>
In-Reply-To: <20080811190131.GL13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808120238.41237.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Suresh Siddha wrote:
> On Sat, Aug 09, 2008 at 08:05:21PM -0700, Herbert Xu wrote:
> > > void irq_ts_restore(int TS_state)
> > > {
> > >       if (!in_interrupt())
> > >               return 0;
> > 
> > This check isn't necessary.
> > 
> > >
> > >       if (TS_state)
> > >               stts();
> > > }
> > 
> > But yes this scheme looks good to me.
> 
> Appended the complete patch. Wolf, can you please help test this again
> and check the perf aswell.

Yes, I'll test that tomorrow.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196-276
Fax: +49 89 38196-144
wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
