Return-Path: <linux-kernel-owner+w=401wt.eu-S2992490AbXCWQKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992490AbXCWQKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992502AbXCWQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:10:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42080 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992490AbXCWQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:10:29 -0400
Subject: [Patch 0/7] integrity service framework and provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:08:59 -0400
Message-Id: <1174666139.11149.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have addressed the issues raised in the previous RFC postings and 
are now submitting these for your consideration.

This is a set of updates to the integrity service framework, previously 
accepted into -mm, EVM a new integrity service provider, and a new LSM 
module called Integrity Based Access Control(IBAC), a sample consumer of
the integrity framework API.

A corresponding userspace utility package is available at 
http://www.research.ibm.com/gsal/tcpa

Patch 1/7 integrity:new hooks
Patch 2/7 integrity:fs hook placement
Patch 3/7 integrity:EVM as an integrity service provider
Patch 4/7 integrity:IMA integrity_measure() support
Patch 5/7 integrity:mtime patch for mmap files
Patch 6/7 integrity:TPM internal kernel interface
Patch 7/7 integrity:Integrity Based Access Control(IBAC)


