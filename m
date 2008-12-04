Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYLDNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYLDNGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYLDNGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:06:25 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54085 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYLDNGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:06:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.175697908@goodmis.org>
Date: Thu, 04 Dec 2008 04:55:56 -0800
In-Reply-To: <20081204052735.175697908@goodmis.org> (Steven Rostedt's message
	of "Thu, 04 Dec 2008 00:26:40 -0500")
Message-ID: <m11vwoumjn.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> From: Steven Rostedt <srostedt@redhat.com>
>
> Impact: clean up
>
> Eric Biederman suggested using the struct pid for filtering on
> pids in the kernel. This patch is based off of a demonstration
> of an implementation that Eric sent me in an email.

Please find_get_vpid and pid_vnr.  

Eric
