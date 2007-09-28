Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbXI1E67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbXI1E67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 00:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXI1E6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 00:58:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:55170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbXI1E6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 00:58:51 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Problems with SMP & ACPI powering off
Date: Fri, 28 Sep 2007 00:57:44 -0400
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       simon.derr@bull.net
References: <46FC20B7.4000606@rtr.ca> <200709280000.53001.rjw@sisk.pl>
In-Reply-To: <200709280000.53001.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709280057.44789.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007 18:00, Rafael J. Wysocki wrote:
> On Thursday, 27 September 2007 23:29, Mark Lord wrote:
> > Question:  do we disable all CPUs except 0 when doing ACPI power off?
> 
> No, but we should.

We used to.
It is absolutely mandatory -- else it confuses the BIOS on some boards
b/c it isn't expecting SMM to get entered from other than cpu0.

-Len
