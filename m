Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718Ab0A1NYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0A1NYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179Ab0A1NYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:24:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36695
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab0A1NYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:24:20 -0500
Date: Thu, 28 Jan 2010 05:24:32 -0800 (PST)
Message-Id: <20100128.052432.251700168.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100128184423.40ce38fb.sfr@canb.auug.org.au>
References: <20091214163338.f811722f.sfr@canb.auug.org.au>
	<20100128184423.40ce38fb.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Jan 2010 18:44:23 +1100

> I am still seeing these.  Is it my compiler version (gcc4.4.0)?

You can't turn on DEBUG_STRICT_USER_COPY_CHECKS and
expect a successful build.  It's for developers to
look at the errors that are generated and audit those
cases in detail.

You'll get the same exact errors as on i386.

Please just elide the option from your test builds.

Thanks.
