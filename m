Return-Path: <linux-kernel-owner+w=401wt.eu-S1764775AbXHQQ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764775AbXHQQ07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXHQQ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:26:50 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:47756 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751183AbXHQQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:26:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Sff22JrgzkgxRkmaqmZmh5t9Z9uGisJ+PBSsE/Bh5f9HT5uBb8HTiCcscbye6nw8Aqj+nTuFBB/Oo768Xkzbon8uQW11Q4sr56uvx6SjojW745ySz5eUEdGz12PW+mh/xMSuHg1bV5mrY6eXq/uXSgINT+deah9224WbHEKe1Oo=  ;
X-YMail-OSG: PCPqkFkVM1lMVsLS.Q4JbCCMBPLJXnyxreFQJiyGr0gfC_XI3kdHqCwCAfkbqs6.dxg5MuOKqRe1zVAiNufh8vhy7X8w4pGzhEteFhZUN4g9ceMHp823LnwBhVohF5Z2EZ1TkNaavAAE3CWbQgl4tzjbt_JEAjY20Q--
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 09:26:44 -0700
User-Agent: KMail/1.9.6
Cc: jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
References: <200708170823.15894.david-b@pacbell.net> <200708170902.01260.david-b@pacbell.net> <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
In-Reply-To: <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708170926.45194.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Atsushi Nemoto wrote:
> 
> > My preferred style for such patches puts the MODULE_ALIAS up
> > near the strange driver name, so it's more clear what's going
> > on.  Putting all the MODULE_*() stuff at the end of the file
> > gets confusing in this case.
> 
> OK, then I should update my patches anyway ;)

I wasn't going to be too picky here, but if you volunteer
to make things even better, I'll be happy!  :)


> Which do you prefer, MODULE_ALIAS or change some strings?
> 
> I guess there are some out-of-tree users of this driver, but fixing
> them is really trivial, so I don't think this is a big compatibility
> problem.

If you're willing to fix all the in-tree users, I'd think
not needing MODULE_ALIAS is best in the long term.

For these I2C drivers, the conversion to support "new style"
driver binding is new in 2.6.23, yes?  If so, I don't see any
real downside to making the driver and module names match.

_ Dave

