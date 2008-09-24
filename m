Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYIXVnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYIXVnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYIXVnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:43:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45827 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbYIXVnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:43:04 -0400
Date: Wed, 24 Sep 2008 16:42:42 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [RFC v5][PATCH 0/9] Kernel based checkpoint/restart
Message-ID: <20080924214242.GA27875@us.ibm.com>
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

Playing around a bit, all seems to work as advertised.

Has anyone playing with this run into any oopses with the latest
version?

Cedric, could you send out your patch (or a pointer to them) to make
ckpt/restart on another task work, so we can pound the core code a bit
harder with liblxc?

thanks,
-serge
