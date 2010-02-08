Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0BHXnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:43:40 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:59401 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0BHXni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l0mcFC09eCzri0QBRoHSHcA7aBzkY4qAfip1a0fr6wVKD+PI5oIlL+mBzdLdflTgd1
         JvPyRR4mASc0TqvUFSX9Mdpxp4+03wlszlya4nvToBa9zc3vBqZl36GqqkttirmPnti6
         glxPwaNgh0f0XQTTuHko4Ucgy5gR7b90u9cxw=
MIME-Version: 1.0
In-Reply-To: <iuJeop2ribM.A.o7H.jY1bLB@chimera>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
	 <iuJeop2ribM.A.o7H.jY1bLB@chimera>
Date: Mon, 8 Feb 2010 15:43:37 -0800
Message-ID: <4807377b1002081543p33e13f0bv140141316ff6278f@mail.gmail.com>
Subject: Re: [Bug #15042] socket(PF_INET6 hangs when ipv6 not yet initialized
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 7, 2010 at 4:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15042
> Subject         : socket(PF_INET6 hangs when ipv6 not yet initialized
> Submitter       : Marc Haber <mh+linux-kernel@zugschlus.de>
> Date            : 2010-01-10 14:28 (29 days old)
> References      : http://marc.info/?l=linux-kernel&m=126313553029280&w=4

probably fixed by this patch:
http://marc.info/?l=linux-netdev&m=126565759512718&w=2
