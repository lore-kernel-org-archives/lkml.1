Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZI2Slx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZI2Slx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZI2Slw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZI2Slv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:41:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
In-Reply-To: Sukadev Bhattiprolu's message of  Tuesday, 29 September 2009 11:05:37 -0700 <20090929180537.GD4625@us.ibm.com>
X-Fcc: ~/Mail/linus
References: <20090924165548.GA16586@us.ibm.com>
	<20090924170308.GH16989@us.ibm.com>
	<200909242343.59903.arnd@arndb.de>
	<20090925082346.GB4436@localdomain>
	<20090925105632.GG12824@hawkmoon.kerlabs.com>
	<20090929180537.GD4625@us.ibm.com>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20090929184023.532DF34@magilla.sf.frob.com>
Date: Tue, 29 Sep 2009 11:40:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why add a new syscall at all instead of just using a new CLONE_* flag to
indicate that the argument layout is different?
