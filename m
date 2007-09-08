Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbXIHXeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbXIHXeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 19:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXIHXd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 19:33:57 -0400
Received: from mail98.megamailservers.com ([216.251.36.98]:37782 "EHLO
	mail98.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074AbXIHXd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 19:33:57 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1189291899.13467.20.camel@Tachyon.home>
References: <1189291899.13467.20.camel@Tachyon.home>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sat, 08 Sep 2007 19:33:15 -0400
Message-Id: <1189294395.13467.39.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-09 at 18:51 -0400, James C. Georgas wrote:
> If I select X86_64_ACPI_NUMA, then ACPI_NUMA is (properly) selected
> automatically, but ACPI is not selected automatically. This causes
> ACPI_NUMA to not be built, and the kernel compile fails with unresolved
> symbols.
> 

Uh, it seems that I'm getting different results this time. Now,
X86_64_ACPI_NUMA does select ACPI, but PM (parent of ACPI) is not
automatically selected. Same result for the compile, though. Boom.

I seem to get different behaviour in general on subsequent runs of make
menuconfig.

For example, the last time I ran it, I was able to select K8_NUMA and
X86_64_ACPI_NUMA, independently of one another.

This time, though, the visibility of K8_NUMA is dependent on whether or
not X86_64_ACPI_NUMA is selected.

Should K8_NUMA and X86_64_ACPI_NUMA both be under NUMA, and independent
of one another?

James
	/\V

