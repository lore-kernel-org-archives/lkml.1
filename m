Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbYEAVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbYEAVff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765857AbYEAVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:34:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:64190 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbYEAVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=umx2RDEgkWzgQsYZEQbUIF586wAh2M0tKrTaCMMaqb58HnaZNJu2Iq6K9g9DJppKrWnAoHnCVGifFlTcSQszbao/ErZXSYsdTDOOF2z48etiIG0yOA3Hv40Xkk5EAbScwJ6x0MJ24hZ0cQvBlb2c+enKX2mzMJWmI019uYJjD9U=
Subject: Re: [PATCH 1/4] lib: add ascii hex helper functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209677314.4841.13.camel@localhost>
References: <1209675067.24729.165.camel@brick>
	 <1209677314.4841.13.camel@localhost>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:35:06 -0700
Message-Id: <1209677706.24729.173.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 14:28 -0700, Joe Perches wrote:
> On Thu, 2008-05-01 at 13:51 -0700, Harvey Harrison wrote:
> > Everyone rolls their own version around the tree, centralize
> > in lib/hexdump.c
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  include/linux/kernel.h |    6 +++++-
> >  lib/hexdump.c          |   25 +++++++++++++++++++++++--
> >  2 files changed, 28 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 4d46e29..20cae9a 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -276,7 +276,11 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
> >  				const void *buf, size_t len, bool ascii);
> >  extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
> >  			const void *buf, size_t len);
> > -#define hex_asc(x)	"0123456789abcdef"[x]
> > +
> > +extern const char hex_asc[];
> 
> I don't see a reason hex_asc should be extern.
> It's only used by hexdump.
> I think it better to remove hex_asc from kernel.h altogether.
> 
> 

The whole point is to start to centralize everybody's private copy of
a hex_asc equivalent.

Harvey

