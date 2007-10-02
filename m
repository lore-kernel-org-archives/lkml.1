Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXJBLbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXJBLbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXJBLa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:30:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:58194 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbXJBLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=frQm0GpaDb7DDitIxghtACBMUAu+dw1W9k4AzgLPvuYU0yRCiiU0pJs6UF5824v4h8VDJvxGKi04rXX1uWbTGAS52owLVWnmWfV9vQJpTxO5aBezAV9rG3Sgfmln45lpqb+A53+Cbuk8vfmx9Y1vCIPhdhBIoiq1mNfHaB53GoI=
Message-ID: <a425f86c0710020430o3507eeb2veb104dc936f230dd@mail.gmail.com>
Date: Tue, 2 Oct 2007 14:30:42 +0300
From: "Kalle Pokki" <kalle.pokki@iki.fi>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bryan.wu@analog.com
Subject: Blackfin Ethernet MAC driver compile error
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: b7cc814dfc400689
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin Ethernet MAC driver does not compile. It seems the driver is
missing some pinmux defines.

  CC      drivers/net/bfin_mac.o
drivers/net/bfin_mac.c: In function 'setup_pin_mux':
drivers/net/bfin_mac.c:275: error: 'P_MII0' undeclared (first use in
this function)
drivers/net/bfin_mac.c:275: error: (Each undeclared identifier is
reported only once
drivers/net/bfin_mac.c:275: error: for each function it appears in.)
drivers/net/bfin_mac.c:279: error: implicit declaration of function
'peripheral_request_list'
drivers/net/bfin_mac.c:285: error: implicit declaration of function
'peripheral_free_list'
make[2]: *** [drivers/net/bfin_mac.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
