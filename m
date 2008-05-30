Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYE3EiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYE3EiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYE3Ehc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:37:32 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46627 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753056AbYE3Ehb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:37:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=lXmcfNv93/AhgaLUM4RDL0m+pExCfiKa6ATCXlOlXW+DchC699cSQGvt4S9PDb9aEP/oNWnCk7oPb99ah+jn/3sX21uB04t5f2hQOyo4t9fLAPhEkVsC0nUS5IBXl7VY+ouEYivbvWE+LeMZy/3NqdV7yiWBNhBm/j7kTjJKNeY=  ;
X-YMail-OSG: iGeutsAVM1nyD094vUdt4c77th5RhsSMi2l_3w7kakJ.w7grNzFK9Xf7KGJFmq813tTy.sTrL6Kyo5CUUd6T8.lrLw79wymOlzBDPvblCCfxYyZQdFMcoOTr2f4VI1BGTOQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Date: Thu, 29 May 2008 21:34:19 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, mingo@elte.hu, pavel@suse.cz
References: <200805291333.42057.david-b@pacbell.net> <200805292329.48896.rjw@sisk.pl> <20080529160632.816e1720.akpm@linux-foundation.org>
In-Reply-To: <20080529160632.816e1720.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805292134.19388.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008, Andrew Morton wrote:
> 
> > Could you check, please?  The previous version didn't.
> > 
> 
> There's just one trivial reject against the PCI tree's
> pm-introduce-new-top-level-suspend-and-hibernation-callbacks:

Thanks Andrew ... in that case I'm not going to worry
about any "-next" issues for now.

- Dave


> ***************
> *** 293,299 ****
>         if (suspend_ops->finish)
>                 suspend_ops->finish();
>    Resume_devices:
>         device_resume();
>    Resume_console:
>         resume_console();
>    Close:
> --- 342,350 ----
>         if (suspend_ops->finish)
>                 suspend_ops->finish();
>    Resume_devices:
> +       suspend_test_start();
>         device_resume();
> +       suspend_test_finish("resume devices");
>    Resume_console:
>         resume_console();
>    Close:


