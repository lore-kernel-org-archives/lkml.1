Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZHMDxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZHMDxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZHMDxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:53:19 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:28233 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZHMDxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:53:19 -0400
Date: Wed, 12 Aug 2009 23:53:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Regression in ACPI in 2.6.31-rc5
In-reply-to: <200908072333.24631.storm@sys49152.net>
Message-id: <alpine.LFD.2.00.0908122350560.22946@localhost.localdomain>
References: <200908072333.24631.storm@sys49152.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had two drivers stop working in 2.6.31 that were working fine in 2.6.30. 
> They are iwlagn and sky2. If i pass acpi=off to the kernel, they work as 
> expected.

the bug report for this issue is here:
http://bugzilla.kernel.org/show_bug.cgi?id=13940

is it possible to bisect which commit between 2.6.30 and 2.6.31-rc5
caused this regression?

Please attach the dmesg from the working 2.6.30
and the acpi=off 2.6.31 to the bug report so i can compare
them to the failing 2.6.31

thanks,
Len Brown, Intel Open Source Technology Center

