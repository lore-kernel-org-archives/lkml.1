Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbXCERKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbXCERKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXCERKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:10:38 -0500
Received: from tcsfw4.tcs-sec.com ([65.127.223.133]:33743 "EHLO
	tcsfw4.tcs-sec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXCERKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:10:37 -0500
Reply-To: <vyekkirala@trustedcs.com>
From: "Venkat Yekkirala" <vyekkirala@trustedcs.com>
To: "'James Morris'" <jmorris@namei.org>
Cc: "'Eric Paris'" <eparis@parisplace.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
       "Venkat Yekkirala" <vyekkirala@tcsfw4.tcs-sec.com>,
       <cxzhang@watson.ibm.com>, "Stephen Smalley" <sds@tycho.nsa.gov>
Subject: RE: [PATCH] xfrm_policy delete security check misplaced
Date: Mon, 5 Mar 2007 11:10:04 -0600
Message-ID: <001801c75f49$1e1989f0$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2911.0)
Importance: Normal
In-Reply-To: <Line.LNX.4.64.0703051139040.14821@d.namei>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > Signed-off-by: Eric Paris <eparis@redhat.com>
> > Acked-by: Venkat Yekkirala <vyekkirala@trustedcs.com> 
> 
> What about your previous comment:
> 
>  "I guess you meant to do this here?
>         else if (err)
>                 return err; "

I saw that this was taken care of in patch-2 for the delete case, but
while err isn't currently applicable to the non-delete case, it would
be proper/complete for err to still be handled for the non-delete case.
Thanks for asking.
