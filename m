Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbYD2WrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbYD2WrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYD2Wqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:46:54 -0400
Received: from ns.firmix.at ([62.141.48.66]:4097 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYD2Wqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:46:53 -0400
Subject: Re: cross-compiling on OS X, make menuconfig fails
From: Bernd Petrovitsch <bernd@firmix.at>
To: Timur Tabi <timur@freescale.com>
Cc: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48173607.6080307@freescale.com>
References: <481529B6.6030802@freescale.com>
	 <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de>
	 <48173607.6080307@freescale.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 30 Apr 2008 00:46:32 +0200
Message-Id: <1209509192.4240.1.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-9.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.334 required=5
X-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 09:51 -0500, Timur Tabi wrote:
[...]
> But printf is bash, not sh.  I would need to change #!/bin/sh to #!/bin/bash.

Yes, also:
----  snip  ----
{2}type -all printf
printf is a shell builtin
printf is /usr/bin/printf
----  snip  ----
And the latter is part of coreutils.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

