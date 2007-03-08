Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbXCHPut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbXCHPut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXCHPut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:50:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46932 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXCHPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:50:48 -0500
Subject: [RFC][Patch 0/6] integrity service framework and provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Content-Type: text/plain
Date: Thu, 08 Mar 2007 11:03:08 -0500
Message-Id: <1173369788.5981.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request for comments for updates to the integrity service
framework, previously accepted into -mm, and EVM a new integrity service
provider.  A new LSM module called Integrity Based Access Control(IBAC),
a consumer of the integrity framework API, will be posted separately to 
the LSM mailing list.

A corresponding userspace utility package is available at 
http://www.research.ibm.com/gsal/tcpa

Patch 1/6 integrity:new hooks
Patch 2/6 integrity:fs hook placement
Patch 3/6 integrity:EVM as an integrity service provider
Patch 4/6 integrity:IMA integrity_measure() support
Patch 5/6 integrity:mtime patch for mmap files
Patch 6/6 integrity:TPM internal kernel interface


