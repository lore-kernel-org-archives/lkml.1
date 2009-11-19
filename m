Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZKSQtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZKSQtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZKSQtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZKSQtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:49:13 -0500
Date: Thu, 19 Nov 2009 11:48:02 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] notifier atomic call chain notrace
Message-ID: <20091119164802.GA2625@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com> <14acd28665b633909f7e9873861075fd657e9a52.1258580048.git.jbaron@redhat.com> <20091118233815.GA28962@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118233815.GA28962@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 06:38:15PM -0500, Mathieu Desnoyers wrote:
> Would the following patch help ? I use it in the LTTng tree to alleviate
> this problem.
> 

indeed. this patch solves the recursive lockups when lockdep is enabled
and we are doing the jump patching. thanks!

-Jason

