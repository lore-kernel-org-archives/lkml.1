Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYIQOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYIQOQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYIQOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:16:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44659 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYIQOQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:16:23 -0400
Date: Wed, 17 Sep 2008 09:16:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 0/9] Kernel based checkpoint/restart
Message-ID: <20080917141601.GA14010@us.ibm.com>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> These patches implement basic checkpoint-restart [CR]. This version (v5)
> supports basic tasks with simple private memory, and open files (regular
> files and directories only). The main changes include rework of memory
> restart code and response to feedback. See original announcements below.
> 
> Oren.

At the kernel summit, it was asked whether at some point this CR work
could be used as the basis for a new suspend to disk implementation.
I answered that we don't plan to handle kernel threads.  In your
experience, are there any reasons why eventually we couldn't eventually
handle kernel threads?

-serge
