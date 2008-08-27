Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYH0SIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYH0SIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYH0SIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:08:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44819 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYH0SIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:08:36 -0400
Date: Wed, 27 Aug 2008 11:04:41 -0700
From: sukadev@us.ibm.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pid_ns: de_thread: kill the now unneeded
	->child_reaper change
Message-ID: <20080827180441.GB4397@us.ibm.com>
References: <20080824154912.GA3783@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824154912.GA3783@tv-sign.ru>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@tv-sign.ru] wrote:
| de_thread() checks if the old leader was the ->child_reaper, this is not
| possible any longer. With the previous patch ->group_leader itself will
| change ->child_reaper on exit.
| 
| >From now find_new_reaper() is the only function (apart from initialization)
| which plays with ->child_reaper.
| 
| Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
