Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbXLHIKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbXLHIKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXLHIK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:10:29 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:56552 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbXLHIK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:10:28 -0500
Subject: Re: [PATCH] depmod: sort output according to modules.order
From: Jon Masters <jonathan@jonmasters.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
In-Reply-To: <47573403.1060203@gmail.com>
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com>
	 <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com>
	 <47565486.8050701@gmail.com> <20071205190609.GA14997@uranus.ravnborg.org>
	 <47573403.1060203@gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 03:09:52 -0500
Message-Id: <1197101392.20786.159.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 08:28 +0900, Tejun Heo wrote:

> As I said, I don't think leaving duplicate lines in a file which will be
> installed, distributed and used widely is the RTTD.

For what it's worth, I changed the module processing in depmod so that
it doesn't output duplicate entries. Having duplicates is not the right
solution - especially modalias entries that depend entirely upon the
file layout on disk when you run depmod against a kernel.

Thanks for the ordering patches folks - a good idea!

Jon.


