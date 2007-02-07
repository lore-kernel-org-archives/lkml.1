Return-Path: <linux-kernel-owner+w=401wt.eu-S1422699AbXBGTlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422699AbXBGTlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422705AbXBGTlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:41:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:43502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422699AbXBGTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=OhEppOHUG2A4GzXOEaM0XLiP41423Q6rTL6/oCR2ttfh2OSvvMzFDaQfioICAOz/wSVHn0TG62/f+gYqNTHegBLZPg7DAPKrpNIqo4VyVGEluE2nzuJyO/yjr3pVUJhdVkj+yXLMBtapDwW+O2/1AZxpfzpr7mRgVA7/gX3ESLs=
Date: Wed, 7 Feb 2007 21:41:00 +0200
To: Philippe De Muyter <phdm@macqel.be>
Cc: Joe Perches <joe@perches.com>, kkeil@suse.de, kai.germaschewski@gmx.de,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070207194059.GY8991@Ahmed>
References: <20070206160446.GE8991@Ahmed> <1170784337.3688.18.camel@localhost> <20070206204130.GU8991@Ahmed> <20070206211813.GD2649@ingate.macqel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206211813.GD2649@ingate.macqel.be>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:18:14PM +0100, Philippe De Muyter wrote:
> On Tue, Feb 06, 2007 at 10:41:30PM +0200, Ahmed S. Darwish wrote:
> >  
> > -    for (i=nelem-1; i >= 0; i--) {
> > +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
> 
> I would write such decrementing loops as :
> 
>        for (i = ARRAY_SIZE(procfsentries); --i >= 0; ) {
> 
> Long time ago, that produced better code.  I did not check recently though.
[...]
> > -    for (i=nelem-1; i >= 0; i--) {
> > +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
> 
> Same here

Hi Philippe,

Won't this hurt readability ?. I'm not a gcc guru anyway to have an
opinion on such stuff :).

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
