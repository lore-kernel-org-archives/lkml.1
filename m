Return-Path: <linux-kernel-owner+w=401wt.eu-S934615AbXJSMCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615AbXJSMCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765836AbXJSMCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:02:22 -0400
Received: from smtp1.int-evry.fr ([157.159.10.44]:50956 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbXJSMCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:02:21 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Fri, 19 Oct 2007 14:01:56 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710181551.24912.florian.fainelli@telecomint.eu> <20071018173828.159b15dd@ephemeral>
In-Reply-To: <20071018173828.159b15dd@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710191401.56916.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

Le jeudi 18 octobre 2007, Andres Salomon a écrit :
> While I certainly would like to see a generic GPIO API, this one isn't
> really useful for geode GPIOs.  It would be nice to have one that did
> work for us as well.  Unfortunately, I haven't had the chance to give
> much thought to this problem yet.

This one was discussed mostly on the ARM mailing-list and finally made his way 
to the mainline kernel. Though it lacks some functions to change for instance 
a entire GPIO line and not a single bit, it is used on ARM and MIPS systems 
so I would conform with this one for now because it is used by at least two 
or more architectures.
