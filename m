Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXGRUKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXGRUKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762377AbXGRUJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:09:58 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:47980 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762231AbXGRUJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lBmg6j7Ih3yGP3VbMRsjI/nJP7jyRLhdKagGZjgAIpJSsRva1reudBuevlRrnRRCMHJpfnWKdl8qzF5FtMGHNmlkb1HBzAWl5VMyo6s9sAdrkP8GWA8fd/OZcWysUF2m/5k3ZLWlSC8WkdDV4z2CztUHkG+tGesAjw2U+18ipLI=
Message-ID: <524f69650707181309w42d665c9ua49179b9d7e0a6b1@mail.gmail.com>
Date: Wed, 18 Jul 2007 15:09:55 -0500
From: "Steve French" <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: -mm breaks and merging maintainer git trees with mainline
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What is the currently recommended procedure for merging a maintainer
tree with mainline in order to reorder all of the fixes in the
maintainer tree, after the changes in the linux-2.6. tree (to make the
eventual merge from Linus easier)?

In this particular case, the
http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git tree
has a few dozen changesets that are not in its parent yet (and the
cifs-2.6.git is at 2.6.22-rc5 level)
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git) but
mainline now has fixes which affect the same directory as the
maintainer tree maintains.

If I do a "git pull" from cifs-2.6.git tree that will pull in the
required changes from mainline but there will be cluttered merge
messages when Linus pulls cifs-2.6.git into his tree.

What is the current recommended way to handle this?


-- 
Thanks,

Steve
