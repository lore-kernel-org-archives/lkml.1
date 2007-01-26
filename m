Return-Path: <linux-kernel-owner+w=401wt.eu-S1030786AbXAZRAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030786AbXAZRAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030756AbXAZRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:00:10 -0500
Received: from tcsfw4.tcs-sec.com ([65.127.223.133]:25873 "EHLO
	tcsfw4.tcs-sec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030878AbXAZRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:00:07 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 12:00:06 EST
Reply-To: <vyekkirala@trustedcs.com>
From: "Venkat Yekkirala" <vyekkirala@trustedcs.com>
To: "'David Miller'" <davem@davemloft.net>, <michal.k.k.piotrowski@gmail.com>
Cc: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: RE: Linux 2.6.20-rc6
Date: Fri, 26 Jan 2007 10:52:13 -0600
Message-ID: <002e01c7416a$5462fa20$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2911.0)
Importance: Normal
In-Reply-To: <20070125.131237.88342843.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Venkat, I think we should fix this by embedding the flow_cache_genid
> bumps into selinux_netlbl_cache_invalidate() and
> selnl_notify_policyload(), or something like that.
> 

Sure. Sending a patch under separate cover in a minute.

> That way we don't have to pepper CONFIG_XFRM ifdefs all over
> services.c
> 
> Any better ideas?  I'm actually surprised this code gets built
> at all when CONFIG_XFRM is disabled to be honest.  :-)

Me too :)

My apologies...
