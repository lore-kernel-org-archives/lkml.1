Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZFEQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZFEQu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZFEQuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:50:18 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:49472 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZFEQuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:50:17 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [Compile Warning] 2.6.30-rc8 build
Date: Fri, 5 Jun 2009 11:50:15 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051150.17889.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group;

I can't argue with gcc on this one either:

drivers/scsi/sd.c: In function 'sd_read_capacity':
drivers/scsi/sd.c:1451: warning: comparison is always false due to limited range of data type

It reads to my eyes as if the function can never
select read_capacity_16 for very large devices.

Suggestions?

Mike
