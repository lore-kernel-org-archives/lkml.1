Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbYCDD2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbYCDD2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYCDD2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:28:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:24989 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbYCDD2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iUtz68FezroybUkASpislI5nksr5GO2jI5PWJPD8BCx7C60Cu8QyA5RYe148DyhiqENNJBl0maRczrUhS+mLrIMxs0lebsblFAn89/I7D6corDDjA4WF4dcFkto/RzHCAVzi0PSDiJMv4q9+/NW+619hKopflcdiaq0ux8k5Y+s=
Message-ID: <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
Date: Mon, 3 Mar 2008 22:28:19 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCTION__ occurences
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1204588990.22933.28.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204588990.22933.28.camel@brick>
X-Google-Sender-Auth: 1af21f1b99480f74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> __FUNCTION__ is gcc-specific, use __func__
>
>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>   162 files changed, 892 insertions(+), 892 deletions(-)


If we apply this, can it be broken down into several smaller patches?
I am in the midst of a large overhaul of the tuning subsystem, and if
this all gets applied at once, it will wreck havoc on my pending
changesets.

Other than that, I'm fine with this change if that's what we're doing
across the rest of the kernel...  Would just be easier to deal with if
it could be further broken down by subdirectory.

Regards,

Mike Krufky
