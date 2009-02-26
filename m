Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZBZHhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZBZHhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZBZHhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:37:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:54299 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751592AbZBZHhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:37:09 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+RLRNR/5aRUedFg+61VhWeipSlOe2ykTkXvrBAuF
	NHtbO+uj0LaIxP
Date: Thu, 26 Feb 2009 08:37:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4 v9] i.MX31: framebuffer driver
In-Reply-To: <e9c3a7c20902251354x5512c222h41c2c9ebfa290e0b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902260833001.5238@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange> 
 <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com> 
 <Pine.LNX.4.64.0901161106100.4940@axis700.grange> 
 <e9c3a7c20901160939y6b3906fp41531730d4b752a@mail.gmail.com> 
 <Pine.LNX.4.64.0901162048400.9060@axis700.grange>  <4974F208.3020407@intel.com>
  <Pine.LNX.4.64.0901201048090.5126@axis700.grange> 
 <Pine.LNX.4.64.0902191533090.5156@axis700.grange> 
 <1235068604.18650.16.camel@dwillia2-linux.ch.intel.com>
 <e9c3a7c20902251354x5512c222h41c2c9ebfa290e0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Dan Williams wrote:

> On Thu, Feb 19, 2009 at 11:36 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Thu, 2009-02-19 at 07:41 -0700, Guennadi Liakhovetski wrote:
> >> Please, oh, please, wake me up if I'm dreaming... In the patch below all
> >> the indentation in _both_ mx3fb.h and mx3fb.c is with TABs (ok, didn't
> >> check all, a couple). Nun im Linus' git-tree - _ALL_ (that I checked)
> >> indentation is with... BLANKS!!!??? Could someone, please, tell me what
> >> was in that cup of tee I've drunk an hour ago?... Dan, you pushed this
> >> patch via your tree, right? Could you double-check, please?
> >>
> >
> > What a mess.  The other patches in your series were applied and
> > checkpatched from the tarball you sent.  This last fix up patch was not
> > cc'd to lkml so I fell back to applying it from a saved Thunderbird
> > message.  The real issue is that I did not have checkpatch automated
> > from StackedGIT's import command.  Please double check the fix below...
> >
> 
> Sascha,
> 
> Will you be taking this clean-up through your tree?  I don't think it
> is suitable for 2.6.29 and in my opinion it belongs with other IMX
> platform driver fixups targeted for 2.6.30.

__NO__. Please don't. Dan, can you please get my original patch somehow in 
its _original_ form - with TABs and spaces as they were? Please, fix your 
mailer or get another one. In this patch you fixed all spaces at the 
beginning of lines, but not indentation inside lines. E.g.

-#define MX3FB_NAME             "mx3_sdc_fb"
+#define MX3FB_NAME		"mx3_sdc_fb"

the first line (with spaces) is after applying this your patch to the 
current tree, the below line (with TABs) is my original version. Please, 
fix!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
