Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYKQWsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYKQWsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKQWru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:47:50 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42240 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbYKQWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:47:48 -0500
Subject: Enterprise workload testing for storage and filesystems
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Cc: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 07:47:42 +0900
Message-Id: <1226962063.3403.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

High on our list at the recent Linux Foundation end user summit was
obtaining a method of obtaining enterprise workloads (or simulators) we
can run in our own testing environments.  The main problem being that
the data sets used by the systems are usually secret or under regulatory
embargo and thus unobtainable.  However, several participants noted that
regulatory prohibitions also extended to their own in-house IT team,
thus they had had to develop simulators for the workloads which, since
they contained no customer data, might be more widely distributable.

Fidelity National Information Service were the first to try this.
They've kicked off a sourceforge site for their stress testing tool
(which is the same tool they use in their own qualification labs).  The
source for the tool is available here:

http://sourceforge.net/project/showfiles.php?group_id=11026&package_id=298597

And it comes with a fairly detailed readme explaining what it's trying
to simulate and why.  Hopefully this will give us all a much better
insight into both enterprise workloads and the way enterprise IT
departments conduct testing.

Let's see how our storage and filesystem tuning measures up to this.

James


