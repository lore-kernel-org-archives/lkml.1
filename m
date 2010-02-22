Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0BVBaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:30:22 -0500
Received: from mail-qy0-f184.google.com ([209.85.221.184]:61289 "EHLO
	mail-qy0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0BVBaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fQrMq3COLaL8N/kaMWLiz2xWYwfvUffENNDcsY03asUKetTMYCV/clJu4YlMkfzgeA
         YTr1wCpUSL6k8h5Y7fqncXZBpQe84471B+sViyiDjacEXkkmT2s1jcKP4pbnlDCeVqPS
         ferCp9jkWgGnuBoZky5lPKvsgSUKr4hwmaUms=
MIME-Version: 1.0
In-Reply-To: <ClJsQB_ZlxO.A.YyG.4dagLB@chimera>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
	 <ClJsQB_ZlxO.A.YyG.4dagLB@chimera>
Date: Mon, 22 Feb 2010 09:30:17 +0800
Message-ID: <2375c9f91002211730l6835cae1x1693da3d94fccc0c@mail.gmail.com>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15202
> Subject         : lockdep warning during elevator_switch
> Submitter       : Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Date            : 2010-01-31 23:55 (22 days old)
> References      : http://marc.info/?l=linux-kernel&m=126498212613051&w=4
>

This should be fixed by:
http://lkml.org/lkml/2010/2/11/329
