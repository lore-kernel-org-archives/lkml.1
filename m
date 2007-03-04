Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXCDL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXCDL7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXCDL7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:59:19 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3425 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXCDL7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:59:17 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc2-mm1
Date: Sun, 4 Mar 2007 13:01:08 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703041007.31800.m.kozlowski@tuxland.pl> <20070304033445.cff1148f.akpm@linux-foundation.org>
In-Reply-To: <20070304033445.cff1148f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041301.09121.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks.  Are you sure that the kermel hasn't already oopsed when this
> happens?  (netconsole will help).

Not sure. Sometimes system is totaly unusable. Sometimes I can switch to console and 
do limited operations there. Will look into it, will play with netconsole.
 
> The sysrq-P failure is a shame.  Does sysrq-P work as expected _before_ the
> system has failed?

Yes it does.

> It sounds to me like a simple log-level thing.  Did you 
> try typing alt-sysrq-7 first?

Thanks for tip. Till now I usually added something like

*.*                     /dev/tty13

to my /etc/syslog.conf. I guess if sysklogd was somehow 'blocked' I shouldn't
have seen anything, not even the very first sysrq line right?

I'll dig some more and try to catch some data.

Regards,

	Mariusz Kozlowski
