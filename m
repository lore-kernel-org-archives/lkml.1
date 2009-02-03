Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZBCAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZBCAU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZBCAUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:20:20 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:52108 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZBCAUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:20:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g0VG0Lsld7ZAOccTTBfv18U8IAdNTgU9NSsLl+H6MJ4NPm1t3FYeodUNenfOPnXBRO
         eQ0vaqQqAwiSKbb9qrZLa/8P/cFCjy5Zfngn4UPG4/UN9BNgxNW5Wb+/udRu1HLQh7ix
         Ms6xJ4ZMI8PwnEPTH/6WZ4tmj/w5Wll6GR/7I=
Date: Tue, 3 Feb 2009 03:20:13 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balaji Rao <balajirrao@openmoko.org>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, andy@openmoko.com
Subject: Re: [PATCH 1/3] pcf50633_charger: Fix typo
Message-ID: <20090203002013.GA29462@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20090127135238.6875.26314.stgit@fedora.yogi> <20090202144155.8626a1c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090202144155.8626a1c3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 02:41:55PM -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2009 19:22:38 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> > Cc: Andy Green <andy@openmoko.com>
> > Cc: Anton Vorontsov <cbou@mail.ru>
> > ---
> >  drivers/power/pcf50633-charger.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> > index e988ec1..41aec2a 100644
> > --- a/drivers/power/pcf50633-charger.c
> > +++ b/drivers/power/pcf50633-charger.c
> > @@ -199,7 +199,8 @@ static int adapter_get_property(struct power_supply *psy,
> >  			enum power_supply_property psp,
> >  			union power_supply_propval *val)
> >  {
> > -	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
> > +	struct pcf50633_mbc *mbc = container_of(psy,
> > +				struct pcf50633_mbc, adapter);
> >  	int ret = 0;
> >  
> >  	switch (psp) {
> 
> This looks like it fixes a rather fatal bug?

Yeah, the fix is already queued for 2.6.29 (battery-2.6.29 tree).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
