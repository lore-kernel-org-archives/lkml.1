Return-Path: <linux-kernel-owner+w=401wt.eu-S935795AbZFOVp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935795AbZFOVp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934585AbZFOVpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:45:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760355AbZFOVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:45:46 -0400
Date: Mon, 15 Jun 2009 14:45:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Tom=E1=5F=5F_Sz=E9pe?= <szepe@pinerecords.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [2.6.29.x+ FIX] CONFIG_FILE_LOCKING should not depend on
 CONFIG_BLOCK
Message-Id: <20090615144511.aae5e50d.akpm@linux-foundation.org>
In-Reply-To: <20090611024630.GA24852@louise.pinerecords.com>
References: <20090611024630.GA24852@louise.pinerecords.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 04:46:30 +0200
Tom____ Sz__pe <szepe@pinerecords.com> wrote:

> Hello,
> 
> Fix: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.
> Patch against 2.6.29.*, 2.6.30, current.
> 
> inlined please find a trivial fix that makes it possible to run
> complete systems out of an initramfs on current kernels again
> (this last worked on 2.6.27.*).
> 

Please describe the problem more completely.  Why is it not possible? 
What goes wrong?  Your initramfs kernel has CONFIG_BLOCK=n?

Also, please do include a Signed-off-by: with each patch - see
Documentation/SubmittingPatches for a description.

Thanks.

