Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbXJaAgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbXJaAgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXJaAfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:35:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:31286 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbXJaAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pZ/na6UooUevT9vZZqeAWWfR/TyaftxJ3Dmp3ei4x4zGfrld7co3/FI9ZPx6MVR8xMoq7hR6T6nFYTxDp4e9e05GkcJaFQxNO2OhWLo6Bn29tJLTClMHYlApmEqOXuvnQ0K1CFVrvQp91hUZo2vecX8l/rReFS0RefwcJ30PUHk=
Message-ID: <5a4c581d0710301735h1682a30bvfbee632c118556d8@mail.gmail.com>
Date: Wed, 31 Oct 2007 01:35:47 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [possibly OT] for_each_netdev() in 2.6.23-gitX / 2.6.24-rc1-gitY breaks Cisco VPN client
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a while I noticed, but I thought someone would as usual
 cook up some fix, while I don't even see the issue been reported...
 if this isn't a Linux kernel/net issue just drop my email, thanks.

Error message during cisco_vpn.ko build:

/download/linux/net/vpnclient/interceptor.c:345:23: error: macro
"for_each_netdev" requires 2 arguments, but only 1 given

 seems like for_each_netdev() now also uses init_net. If there is
 an alternative and somebody could point me to that, it'd be great,
 as understanding the issue is well out of my grasp.

Patching up the vpnclient source to use init_net gets me to depmod
 complaining it's not allowed to use a GPL-only symbol (init_net)
 in a proprietary module. If this is meant to be - fine, and apologies
 for the waste of bandwidth; but if this is simply an unwanted side
 effect of the recent changes, perhaps it's a good idea to have it
 at least reported.

--alessandro

 "you feel the sweet breath of time
  it's whispering, its truth not mine"

   (Interpol, 'No I In Threesome')
