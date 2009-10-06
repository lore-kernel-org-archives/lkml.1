Return-Path: <linux-kernel-owner+w=401wt.eu-S933682AbZJFWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbZJFWbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933509AbZJFWbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:31:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933462AbZJFWbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:31:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: suspend tree build failure
Date: Wed, 7 Oct 2009 00:31:55 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
References: <20091006135505.f07ee40d.sfr@canb.auug.org.au>
In-Reply-To: <20091006135505.f07ee40d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910070031.55135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> kernel/freezer.c:27: error: expected ',' or ';' before '{' token
> 
> Caused by commit 9a4801cb8df76263abbb3049c0208625b7f34286 ("PM / freezer:
> Make refrigerator cold") which neglected to include linux/compiler.h for
> the definition of __cold.

Thanks for the notification.

Did you cross-compile it by chance?  It builds for me on native x86_64 with
allmodconfig, which is why I missed this issue.

> I have used the version of the suspend tree from next-20091002 for today.

I added the #include <linux/compiler.h> to freezer.h, but obviously I couldn't
verify if that fixed the problem.  Hopefully it did.

Pushing updated tree.

Best,
Rafael
