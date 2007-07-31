Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbXGaMyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbXGaMyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbXGaMyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:54:36 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:23424 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbXGaMyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:54:35 -0400
Date: Tue, 31 Jul 2007 14:55:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCHSET 2.6.23-rc1] sysfs: locking fix and cleanups
Message-ID: <20070731145506.3c7d4a40@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11858769082982-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 19:15:08 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Hello, all.
> 
> This patchset contains a locking fix and cleanup patches for sysfs.
> 
> #01	locking fix
> #02	shadow support removal from Eric adapted to apply after #01
> #03-07	clean up patches
> 
> #01 should go mainline as it fixes a locking regression introduced by
> -rc1 merge.  The rest should stay in -gregkh till 24 merge window
> opens up.
> 
> Clean up patches don't introduce any noticeable behavior change.  They
> just refactor and simplify codes.
> 
> Thanks.

FYI: This seems to work well on s390 so far, when attaching/detaching
and moving devices (my standard test cases ;)
