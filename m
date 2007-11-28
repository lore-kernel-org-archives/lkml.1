Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXK1Irg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXK1Irg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 03:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXK1IrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 03:47:25 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:38316 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbXK1IrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:47:24 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, wferi@niif.hu
Subject: Re: [PATCH 1/3] Remove trailing NULs from network bonding sysfs interface.
References: <871wabkxcd.fsf@szonett.ki.iif.hu>
	<20071127194929.757e4ebe.randy.dunlap@oracle.com>
Date: Wed, 28 Nov 2007 09:47:21 +0100
In-Reply-To: <20071127194929.757e4ebe.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 27 Nov 2007 19:49:29 -0800")
Message-ID: <87bq9ekb8m.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> On Wed, 28 Nov 2007 01:49:54 +0100 =?utf-8?q?Ferenc_W=C3=A1gner?= wrote:
>
> Patches 1 & 3 use
>
> 	if (res) statement;
>
> but the preferred form is
>
> 	if (res)
> 		statement;
>
> Even if this style was already used in the source file, it should
> be cleaned up.

No principal problem.  So that I learn something useful: how should I
go about this?  I created the patches with git-format-patch, and they
depend on each other, so I'd rather not git-reset, if possible...

Can I just create a follow-up patch which fixes this stylistic issue?
-- 
Thanks,
Feri.
