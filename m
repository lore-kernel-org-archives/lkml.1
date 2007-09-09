Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXIISn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXIISn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbXIISnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:43:49 -0400
Received: from mail74.megamailservers.com ([216.251.36.74]:48323 "EHLO
	mail74.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297AbXIISns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:43:48 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: [PATCH] KCONFIG: fix pseudo dependency between K8_NUMA and
	X86_64_ACPI_NUMA config options
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070909134602.GA25798@one.firstfloor.org>
References: <1189291899.13467.20.camel@Tachyon.home>
	 <20070908180904.656f3d03.randy.dunlap@oracle.com>
	 <1189300961.13467.47.camel@Tachyon.home> <p734pi4rytz.fsf@bingen.suse.de>
	 <1189343945.7365.9.camel@Tachyon.home>
	 <20070909134602.GA25798@one.firstfloor.org>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sun, 09 Sep 2007 14:43:27 -0400
Message-Id: <1189363407.7365.43.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-09 at 15:46 +0200, Andi Kleen wrote:

> Thanks. How about a fix for the other problem (ACPI_NUMA- PM) too?
> 

I don't want to just hard-select it until I understand what happened
between 2.6.22.6 and current git to make ACPI selectable without PM.

Personally, I think ACPI should be independent of PM anyway (at least as
it is displayed and selectable in the user interface. Obviously there
may be functional relationships between them). There is a "C" in ACPI,
after all, and some of that "C" doesn't really have anything to do with
power management.

James
	/\

