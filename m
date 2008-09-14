Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYINIBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYINIBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYINIBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:01:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15256 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYINIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=DO84L/u4NAaSULVBf3nOa3iUGSspzBJf+OhmxKez0XEgWFZltphC6h9pP68k3Nl6Cv
         RfZwpgja91hqZwP/JuqNPu7/grVTrOf2FUA9A/ABzMXbou1qtp1oHKBmUTiuSL8v/xyt
         ZjD0ISYvxHMBbaTfEt8/rqHVGmE8CTREa+PTk=
User-Agent: quilt/0.46-1
Date: Sun, 14 Sep 2008 11:55:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, linux-kernel@vger.kernel.org
Cc: yhlu.kernel@gmail.com
Subject: [patch 0/2] -tip/master APIC fixes
Message-ID: <48ccc4e3.0437560a.2f7a.5608@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Here are two patches with a few nits fixed

- lapic_setup_esr should inform us if ESR was asked to
  not being touched (this nit is brough in by one of mine
  commit during unification process -- not a serious issue
  but...actually nit, sorry for this)
- dont touch ESR register on 82489DX in setup_local_APIC

  Please review, any comments are highly appreciated!

		- Cyrill-
-- 
