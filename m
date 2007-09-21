Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbXIUSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbXIUSFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXIUSFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:05:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:60163 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbXIUSFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=O/o14PjY6Uj4/BAfPHWmE2kICRKzU+d4kXCXel3WOOaRcbTzGS/sfn0uZ5u1sg+ZIUltbOECVfD9KLGJUj2N45+hBW+3t7rhBQjIRKZhDypCFbXD3MFYZ2EomqJ52DNt3c/qcDlRW+2DJfOT/tukF8apb7BQNQJCQtF2AKB4c/o=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Date: Fri, 21 Sep 2007 19:05:23 +0100
User-Agent: KMail/1.9.1
Cc: jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <200709211201.24475.vda.linux@googlemail.com> <200709211803.55554.vda.linux@googlemail.com> <20070921.104912.41646795.davem@davemloft.net>
In-Reply-To: <20070921.104912.41646795.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211905.23946.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 18:49, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Fri, 21 Sep 2007 18:03:55 +0100
> 
> > Do patches look ok to you?
> 
> I'm travelling so I haven't looked closely yet :-)
> 
> Michael can take a look and I'll try to do so as well
> tonight.

Good.

I plan to use gzip compression on following drivers' firmware,
if patches will be accepted:

   text    data     bss     dec     hex filename
  17653  109968     240  127861   1f375 drivers/net/acenic.o
   6628  120448       4  127080   1f068 drivers/net/dgrs.o
         ^^^^^^

--
vda
