Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZKIOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZKIOK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZKIOK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:10:56 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:47205 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZKIOKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:10:55 -0500
Date: Mon, 9 Nov 2009 15:10:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/23] sysctl mips/lasat: Remove dead binary sysctl
	support
Message-ID: <20091109141034.GA12637@linux-mips.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-15-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257682930-31401-15-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 04:22:02AM -0800, Eric W. Biederman wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
> and .strategy members of sysctl tables are dead code.  Remove them.
> 
> The deleted strategy routines here surprise me.  ctl_name was
> CTL_UNNUMBERED so they would not have been called at all.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
