Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYCQQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYCQQzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYCQQzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:55:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbYCQQzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:55:43 -0400
Date: Mon, 17 Mar 2008 09:55:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] thermal: fix Kconfig dependencies
In-Reply-To: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.00.0803170953210.3020@woody.linux-foundation.org>
References: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Mar 2008, Heiko Carstens wrote:
> 
> Change the select to a depends on to fix this. Should work as well.

Nope, that doesn't work. ACPI_THERMAL will select THERMAL, so now you have 
THERMAL selected without HWMON.

As a minimal fix, you'd at least need to make ACPI_THERMAL depend on 
THERMAL too.

		Linus
