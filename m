Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZBLLYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZBLLYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZBLLXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:23:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36212 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZBLLXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:23:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Cc: kosaki.motohiro@jp.fujitsu.com, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <27421.1234436992@redhat.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27421.1234436992@redhat.com>
Message-Id: <20090212202118.0A58.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 12 Feb 2009 20:23:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


> Aha!  I reproduced it myself (with my patch to check atomic_dec_and_test() in
> there, but not Serge's patch).  Ironically, 13 hours of running Vegard's
> setreuid() program didn't show anything, but halting the box whilst someone
> was trying to SSH-crack it did.

Today's my testing, your patch + serge's patch kernel didn't reproduce the bug
for 12 hour running.

but perhaps I am merely lucky guy.



