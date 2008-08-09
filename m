Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYHIDKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYHIDKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 23:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYHIDJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 23:09:56 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:57674 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbYHIDJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 23:09:55 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sat, 9 Aug 2008 05:09:53 +0200
User-Agent: KMail/1.9.9
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <200808090354.03568.wolfgang.walter@stwm.de> <20080809021649.GA26784@gondor.apana.org.au>
In-Reply-To: <20080809021649.GA26784@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808090509.53679.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Herbert Xu wrote:
> On Sat, Aug 09, 2008 at 03:54:03AM +0200, Wolfgang Walter wrote:
> > On Saturday 09 August 2008, Herbert Xu wrote:
> > > 
> > > Someone please test this with tcrypt mode=200 with and without
> > > the patch.
> > 
> > I'll do that. Where do I find tcrypt?
> 
> It's part of the kernel.  Just make sure you've got CRYPTO_TEST
> enabled as a module.
> 

Ok, that is easy :-). I'll make that test tomorrow. Bed time now :-).

I'll run that test on a unpatched 2.6.25 instead a unpatched 2.6.26 as latter 
will crash. If you want I can use my 2.6.26 where I reverted the FPU state 
changes (see one of my earlier mails for the patch), of course.

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
