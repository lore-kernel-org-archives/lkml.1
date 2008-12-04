Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYLDAOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYLDAOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbYLDAOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:14:08 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50525 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758753AbYLDAOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:14:07 -0500
Subject: Re: [Bug #12020] scsi_times_out NULL pointer dereference
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bernd Schubert <bs@q-leap.de>
In-Reply-To: <bfPM5B8Tx2B.A.Ia.hpxNJB@chimera>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
	 <bfPM5B8Tx2B.A.Ia.hpxNJB@chimera>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 18:14:08 -0600
Message-Id: <1228349648.5551.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 22:57 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

That's a hard call.  We think this might be fixed by Tejun's block timer
patch, but the reporter has been unable to reproduce the problem (with
or without the timer patch).

Perhaps list as closed for now and reopen if we get another problem
report with kernels containing the block timer patch?

James


