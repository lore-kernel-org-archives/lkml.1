Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZHZGZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZHZGZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZHZGZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:25:08 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46460 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZHZGZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NJPn7Wt8WrATMps2+KsyVl2jkRPvzj973CJ6T0E9ZSxwDtiX0RHHu4ShZA4i8tmCgo
         1I5tKllO/+zno/KboTiVYYrZWarosCNOiuYxvZFUFJexq4lcsEwcR3mNsFBQLOfs+dnP
         jris4cKH9W+25kLXWgA6i5sh8EoAJFQJV6qJc=
MIME-Version: 1.0
In-Reply-To: <Cg6cQYLdUxG.A.K-C.U2GlKB@chimera>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	 <Cg6cQYLdUxG.A.K-C.U2GlKB@chimera>
Date: Wed, 26 Aug 2009 09:25:07 +0300
X-Google-Sender-Auth: a5ce47223708d5c4
Message-ID: <84144f020908252325p88178f2yb0a76e033352b78d@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Rientjes <rientjes@google.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Aug 26, 2009 at 12:05 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject         : Page allocation failures with b43 and p54usb
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2009-04-29 21:01 (119 days old)
> References      : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>                  http://lkml.org/lkml/2009/6/7/136
>                  http://lkml.org/lkml/2009/7/26/213
> Handled-By      : Johannes Berg <johannes@sipsolutions.net>
>                  David Rientjes <rientjes@google.com>
> Patch           : http://patchwork.kernel.org/patch/37655/

FYI, the fix (a new slub debugging option) is queued for 2.6.32 and we
don't have plans to backport it to -stable because it depends on SLUB
out-of-memory diagnostic patches and the problem doesn't affect
production configs.

                                Pekka
