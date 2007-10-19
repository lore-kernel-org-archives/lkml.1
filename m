Return-Path: <linux-kernel-owner+w=401wt.eu-S966445AbXJSE12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966445AbXJSE12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXJSE1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:27:19 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbXJSE1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BK8VDllILpJZg/8e4/PSpkT4sDHyqn2RP0mEXCfLHnuOgqGNWJnADHKlVxnsA6cUOqMxq4+YRw29BoijLlO8avhD3s+uMMivYQCimDCl25RTTUMtSxM7NXumMP93YHGUxyZqv+PgxpC9ps1dDt0QaLqk6zh8TtdvOzk8Ok0MngU=
Message-ID: <3aa654a40710182127u529efe5flc01955f01b83b042@mail.gmail.com>
Date: Thu, 18 Oct 2007 21:27:16 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: In function sysctl_check_lookup: undef ref to sysctl_head_next
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good Day,

My randconfig just caught an error on:
kernel/built-in.o: In function `sysctl_check_lookup':
sysctl_check.c:(.text+0x17db1): undefined reference to `sysctl_head_next'
sysctl_check.c:(.text+0x17dc7): undefined reference to `sysctl_head_finish'

Git bisect was unsuccessful due to too many unrelated errors trying to
track down the issue. I also couldn't track down the offending
function. Any idea of the issue?

Against this config: http://avuton.googlepages.com/sysctl-head-next.config

git master: 4fa4d23fa20de67df919030c1216295664866ad7

Thanks,
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
