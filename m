Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbYCDGyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbYCDGyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYCDGyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:54:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:15438 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYCDGyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dmGzs1qQsXFGgMqgMlLDtKTSkoIWEFO5thMSI9FsP86OVjSl2lAJ9SwQMj2Da+l6w2vUwVYd5ia55fsw9QFlEi1sthd/hthwdxHQJAmFr1x4IbDkTQ+9HKNYlE1eq2y9NeOwHKqazTfoFGfHanYFdFJZX9R22H22XJkwbd+PtRI=
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace
	remaining	__FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
       "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <47CCEE63.80103@linuxtv.org>
References: <1204588990.22933.28.camel@brick>
	 <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
	 <47CCDB5F.1040007@gmail.com>  <47CCEE63.80103@linuxtv.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 22:54:21 -0800
Message-Id: <1204613661.22933.110.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 01:38 -0500, Michael Krufky wrote:
> Manu Abraham wrote:
> > Michael Krufky wrote:
> >> On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
> >> <harvey.harrison@gmail.com> wrote:
> >>> __FUNCTION__ is gcc-specific, use __func__
> >>>
> >>>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >>>   162 files changed, 892 insertions(+), 892 deletions(-)
> >>
> >>
> >> If we apply this, can it be broken down into several smaller patches?
> >> I am in the midst of a large overhaul of the tuning subsystem, and if
> >> this all gets applied at once, it will wreck havoc on my pending
> >> changesets.
> >
> > Please make sure your changes don't conflict with the multiproto tree
> > changes.
> >
> > Regards,
> > Manu
> Manu,
> 
> Does that mean that you plan to merge multiproto soon?  If that's the
> case, then we'd be better off if you give Harvey an "exclude list" of
> files he should stay away from.  He can regenerate patches to those
> files after multiproto is merged.
> 

Or just apply it after both of you have merged and ignore any conflicts,
I can come back to it at a later time (2.6.26-rc1 maybe?).

Cheers,

Harvey

