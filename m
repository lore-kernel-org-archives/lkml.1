Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYFCB6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYFCB6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 21:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYFCB5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:57:54 -0400
Received: from saeurebad.de ([85.214.36.134]:39443 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYFCB5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:57:53 -0400
X-Mailbox-Line: From hannes@saeurebad.de Tue Jun  3 02:53:02 2008
Message-Id: <20080603005017.593345596@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 02:50:17 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 00/14] bootmem rewrite v3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ sorry, forgot lkml in CC and misspelled AKs email address (again).
  distracted by birds and such... ]

Hi,

here is the third version of the bootmem clean-up.

I fixed up the documentation mismatches in v2 reported by Chris Malley
and the incorrect bdata->last_success treatment as noticed by Yasunori
Goto (and me! :).

The patches are based on -mmotm and have been compile- and runtime
tested on a x86 32bit uma machine.

More changelog in the patches.

	Hannes

