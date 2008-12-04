Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYLDQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYLDQXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLDQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:23:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34755 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbYLDQXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:23:12 -0500
Date: Thu, 4 Dec 2008 08:22:42 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
Message-ID: <20081204162242.GA23906@us.ibm.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.175697908@goodmis.org> <m11vwoumjn.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812040921410.5240@gandalf.stny.rr.com> <m1abbct3hk.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abbct3hk.fsf@frodo.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| find_get_pid is the right one.
| 
| Sorry.  We have a stupid inconsistency in the naming here,
| If we were consistent it would be find_get_vpid.

Yes, its inconsistent, but maybe find_vpid() should be find_pid()
since there is no 'virtual struct pid' only a virtual pid number.

Sukadev

