Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYAHHYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYAHHYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYAHHX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:23:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57838
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYAHHX4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:23:56 -0500
Date: Mon, 07 Jan 2008 23:23:55 -0800 (PST)
Message-Id: <20080107.232355.228915298.davem@davemloft.net>
To: B.Steinbrink@gmx.de
Cc: arbrandes@gmail.com, bunk@kernel.org, andi@lisas.de, richie@coderworld.net,
       linux-kernel@vger.kernel.org, aabdulla@nvidia.com, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080107014638.GA4170@atjola.homenet>
References: <20080104034357.GA2113@atjola.homenet>
	<b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com>
	<20080107014638.GA4170@atjola.homenet>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Björn Steinbrink <B.Steinbrink@gmx.de>
Date: Mon, 7 Jan 2008 02:46:38 +0100

> On 2008.01.06 19:49:49 -0200, Adolfo R. Brandes wrote:
> >  I have this forcedeth MAC address reversal problem when suspending
> > on 2 distinct boxes.  I can confirm Steinbrink's patch fixes the
> > problem on only one of them:
> > 
> > 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)
> > 
> >  On the other one the problem persists:
> > 
> > 00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)
> 
> Thanks. Leaves me pretty clueless though. Especially since it worked for
> Richard, who also has a MCP51. In a private mail, you said that you had
> hardcoded the mac address in the source. Any chance that you applied the
> patch on your modified sources and didn't get it right?

I am going to push this patch upstream, it is correct and we
have a positive test case that failed before, so overall it's
a net improvement even if we still don't exactly know why
Adolfo's case still fails.

Let me know if there are any follow-on patches.

Thanks.
