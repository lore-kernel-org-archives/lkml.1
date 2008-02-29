Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYB2JTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYB2JTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYB2JTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:19:41 -0500
Received: from ns.firmix.at ([62.141.48.66]:3534 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYB2JTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:19:39 -0500
Subject: Re: swap file over jffs2 partition
From: Bernd Petrovitsch <bernd@firmix.at>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47C772E9.2000000@gmx.net>
References: <47C772E9.2000000@gmx.net>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 29 Feb 2008 10:19:23 +0100
Message-Id: <1204276763.18969.10.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.33 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.33 required=5
X-Spam-Score: -2.33 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2008-02-29 at 04:50 +0200, Dimitrios Apostolou wrote:
> Hello list,
> 
> I intend to build a diskless linux system (root over NFS). Because it
> has 1GB of embedded flash storage, I'm thinking of using this as swap 
> (I've been bitten many times by the problems linux has with *no* 

Put more RAM on the hardware and/or reduce the software on it.
If that means heavily customizing the distribution: Do it.
If that means you can't run some specific common distribution[0]: Throw
it out and roll your own minimalistic one with just the tools and
especially libraries you need.
We run Linux on embedded hardware all the time without swapspace without
any problems (related to the "missing" swapspace).

> swap...). And to avoid wearing out the flash storage too fast, I 'm 

Swapping (and constantly writing logfiles) will wear it out much faster
than without. Perhaps not at development time but for sure in the field.

[....]

	Bernd

[0]: Which I highly doubt.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


