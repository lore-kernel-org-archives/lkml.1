Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZCQPCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZCQPCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZCQPCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:02:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38212 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZCQPCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:02:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
Date: Tue, 17 Mar 2009 16:07:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: jkosina@suse.cz, gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <6648.1237271589@turing-police.cc.vt.edu>
In-Reply-To: <6648.1237271589@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903171607.20942.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 17 März 2009 07:33:09 schrieb Valdis.Kletnieks@vt.edu:
> Yes, there's an NVidia driver loaded - but this looks like an HID/USB
> bug, where it's shooting itself in the foot by flushing the workqueue while
> not realizing it's in a worker thread already, thus deadlocking.

I am looking into it. Do you know why you get a reset?

	Regards
		Oliver

