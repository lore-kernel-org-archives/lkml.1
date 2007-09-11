Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbXIKWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbXIKWFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbXIKWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:05:47 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:32842 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXIKWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sNpEaUOBwdLqhaZScbVCJTA+04OvIPHMcY+pZDS38WnWXgIam5qTU2l6D+3L1yQq+qGi2N9XDMlJb3EF/u6ONrlSfgIeNDxqBnUWD8cH6gHd2V5LRlqw5ryQaGsuctMLWAOEIKB2bMcvkVVi8Ftyd14mVQGStQO1C0tmFY+rybs=
Message-ID: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com>
Date: Tue, 11 Sep 2007 23:05:44 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: time_after - what on earth???
Cc: "Paul Mundt" <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, why does this line occasionally return true:

	if ((maple_dev->interval > 0) && (jiffies >maple_dev->when))

while this one never does (no other changes made):

if  ((maple_dev->interval > 0) && (time_after(jiffies, maple_dev->when)))


Is this a gcc issue or what?
