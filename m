Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbZBMEpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbZBMEpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZBMEov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:44:51 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43332 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZBMEou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:44:50 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Cc: kosaki.motohiro@jp.fujitsu.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <12311.1234459104@redhat.com>
References: <20090212143932.GA10101@us.ibm.com> <12311.1234459104@redhat.com>
Message-Id: <20090213134326.77C0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Feb 2009 13:44:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > 	1. put_user_ns() was being called before the uid (which
> > 	   was in the init_user_ns) was unhashed
> 
> Ah yes...  but only if CONFIG_USER_NS=y.  Otherwise the unhash was being done
> before the release anyway.  With this option set, the unhash was being deferred
> to a workqueue thread.
> 
> Okay, that seems reasonable.

Serge's patch servive on my stress workload for >24 hour.
then, I think his patch have fixed this issue.

thanks.



