Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbXHBJ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbXHBJ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXHBJ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:26:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42271
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbXHBJ0F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:26:05 -0400
Date: Thu, 02 Aug 2007 02:26:05 -0700 (PDT)
Message-Id: <20070802.022605.44936803.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: darryl-mailinglists@netbauds.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: TCP SACK issue, hung connection, tcpdump included
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0708021056560.8788@kivilampi-30.cs.helsinki.fi>
References: <20070729160721.GA31276@1wt.eu>
	<46AEC286.2030302@netbauds.net>
	<Pine.LNX.4.64.0708021056560.8788@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 2 Aug 2007 12:23:23 +0300 (EEST)

> ...Seriously, somebody else than me is probably better in suggesting what 
> could cause the discarding at the SERVER in this case. SNMP stuff Dave was 
> asking could help, you can find them from /proc/net/{netstat,snmp}...

That will also tell us if TCP discarded the packet due to
timestamps tests or similar.
