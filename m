Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbZIHRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbZIHRYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZIHRYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:24:52 -0400
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:41752 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750912AbZIHRYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:24:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GAhUcXOx47hq8Se2T+QrYkdLKxtFsdWB1klaxcfL5KctaK/y1f04JLOWhMg+DKOWNkrC5O1D/WnSUibGnO1zrV4p9uGU9H0qpTsKVpBD85YEPZidG0gdufd+hHnyzZ3e;
Date: Tue, 8 Sep 2009 10:24:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>,
       "ling.ma@intel.com" <ling.ma@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Reinette Chatre" <reinette.chatre@intel.com>
Subject: Re: [Bug #13819] system freeze when switching to console
Message-ID: <20090908102418.673504ae@jbarnes-g45>
In-Reply-To: <Vm51Upp4EV.A.r-D.mgBpKB@chimera>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	<Vm51Upp4EV.A.r-D.mgBpKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Sep 2009 19:24:50 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
> Subject		: system freeze when switching to console
> Submitter	: Reinette Chatre <reinette.chatre@intel.com>
> Date		: 2009-07-23 17:57 (46 days old)

So simply switching VTs causes this problem too?  Based on your initial
description it sounds like a panic (keyboard LEDs were flashing).  If
it happens at VT switch time you should be able to capture the panic
output with netconsole like Linus mentioned.

-- 
Jesse Barnes, Intel Open Source Technology Center
