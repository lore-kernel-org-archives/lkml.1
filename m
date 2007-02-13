Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXBMFZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXBMFZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXBMFZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:25:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:35046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161021AbXBMFZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:25:01 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Subject: Re: /proc/acpi/ac_adapter/AC is missing after latest ACPI merge
Date: Tue, 13 Feb 2007 00:23:15 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200702122045.34951.ismail@pardus.org.tr>
In-Reply-To: <200702122045.34951.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702130023.15495.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 13:45, Ismail Dönmez wrote:
> Hi all,
> 
> After latest ACPI merge /proc/acpi/ac_adapter/AC has gone fishing :
> 
> [~]> ls -al /proc/acpi/ac_adapter/
> dr-xr-xr-x  2 root root 0 Şub 12 20:44 ADP1
> 
> [~]> ls -al /proc/acpi/ac_adapter/ADP1
> -r--r--r-- 1 root root 0 Şub 12 20:44 state
> 
> This at least breaks HAL which thinks AC is always plugged in, is this change 
> intentional?

no change intended here.

grep CONFIG_ACPI_AC .config

lsmod |grep ac

cheers,
-Len
