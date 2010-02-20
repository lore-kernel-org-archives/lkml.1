Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0BTOpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:45:31 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:47160 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab0BTOp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:45:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l9GNZDhOAuCbN2VP3Y4s1NwAoUL/Qqz/GON1J6dBKvCvj7OoeO/0iSZbLsLtdwik20
         teu/cVYzuDXktRJtSJOSQBClCC7+WV4NRIthBHsss0+/dpymAWDJfFp4Eo2bZ5PCiykZ
         +lwlNibEwTjOjORsoPHlEM9gkUwd7af87iXhQ=
Date: Sat, 20 Feb 2010 22:48:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jouni Malinen <j@w1.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: [Bug #15308] 2.6.33-rc8 breaks UML with Restrict initial stack
	space expansion to rlimit
Message-ID: <20100220144810.GF3000@hack>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera> <4un6Gst5rKB.A.u_F.UiIeLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4un6Gst5rKB.A.u_F.UiIeLB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:38:37AM +0100, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a summary report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.32.  Please verify if it still should be listed and let the tracking team
>know (either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15308
>Subject		: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
>Submitter	: Jouni Malinen <j@w1.fi>
>Date		: 2010-02-14 16:40 (1 days old)
>First-Bad-Commit: http://git.kernel.org/git/linus/803bf5ec259941936262d10ecc84511b76a20921
>Message-ID	: <20100214164023.GA2726@jm.kir.nu>
>References	: http://marc.info/?l=linux-kernel&m=126616751807902&w=4
>Handled-By	: Michael Neuling <mikey@neuling.org>
>

It should be fixed by this patch:

http://lkml.org/lkml/2010/2/15/61

