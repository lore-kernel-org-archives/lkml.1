Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYC0XIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYC0XIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYC0XIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:08:16 -0400
Received: from ozlabs.org ([203.10.76.45]:37340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYC0XIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:08:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18412.10455.702432.911134@cargo.ozlabs.ibm.com>
Date: Fri, 28 Mar 2008 10:08:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Olof Johansson has a defconfig update for the pasemi platform that he
would like to have in 2.6.25, so please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

Thanks,
Paul.

 arch/powerpc/configs/pasemi_defconfig |  142 ++++++++++++++++++++-------------
 1 files changed, 88 insertions(+), 54 deletions(-)

commit 5c29934de29ddd7ecd913d83cad28e872f2e8c78
Author: Olof Johansson <olof@lixom.net>
Date:   Tue Mar 25 10:28:26 2008 -0500

    [POWERPC] update pasemi_defconfig
    
    Disable GEN_RTC since it conflicts with the i2c rtc drivers registering,
    besides that keep most of the new defaults.
    
    Signed-off-by: Olof Johansson <olof@lixom.net>
