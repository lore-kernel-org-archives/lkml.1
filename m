Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177Ab0A0JKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0A0JKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900Ab0A0JKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:10:48 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:54687 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0A0JKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KR5ZQxb8XhTHGnfbsiiBoceBVmJWkItGVpqcpVvCZyEaNhhz9XeW07b1DJvYCbmqUx
         qHB5r6iGUAND8zYEQsT8bICKZVxD8abm5/TRpXyEauDUE1SYtT7T2R0zwoapRTXNzP4p
         okcKrzcdVb+fUYDw80fLXE6MAC8CBZZjZa6RE=
MIME-Version: 1.0
In-Reply-To: <q60Z28d_9yH.A.oqH.NZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A.oqH.NZMXLB@chimera>
Date: Wed, 27 Jan 2010 17:10:44 +0800
Message-ID: <2375c9f91001270110t2a8d08b8n4578df310a6129@mail.gmail.com>
Subject: Re: [Bug #15042] socket(PF_INET6 hangs when ipv6 not yet initialized
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 6:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15042
> Subject         : socket(PF_INET6 hangs when ipv6 not yet initialized
> Submitter       : Marc Haber <mh+linux-kernel@zugschlus.de>
> Date            : 2010-01-10 14:28 (15 days old)
> References      : http://marc.info/?l=linux-kernel&m=126313553029280&w=4
>

(Adding net-dev into Cc)

Hi, Marc,

Sorry, I don't really understand your description of the problem, your mean
your ssh hangs on socket PF_INET6 for 30 seconds?

Have you enabled CONFIG_DETECT_SOFTLOCKUP for your kernel?
If not, please do it.

Thanks.
