Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZAKPEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZAKPEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZAKPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:04:09 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:63027 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZAKPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:04:06 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: git@vger.kernel.org
Subject: current git kernel has strange problems during bisect
Date: Sun, 11 Jan 2009 16:02:53 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111602.53082.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doing a 
git bisect start
git bisect good a3a798c
git bisect bad v2.6.29-rc1

results in a repository without several files, e.g Makefile!
git describe also fails.

Any ideas how to fix this problem to continue with my bisect?

Christian
