Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbYANPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbYANPtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYANPtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:49:00 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56284 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYANPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:48:59 -0500
Subject: Checkpatch.pl failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: rdunlap@xenotime.net, apw@shadowen.org, jschopp@austin.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 09:48:53 -0600
Message-Id: <1200325734.3159.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error:

ERROR: no space before that close parenthesis ')'
#501: FILE: drivers/scsi/dpt_i2o.c:2299:
+               if (dev_status == 0x02 /*CHECK_CONDITION*/) {

Is definitely wrong.  I think it's stripped the comments so now the if
looks to have a space before the bracket, but stylistically the
complaint it has errored out for is wrong.

James


