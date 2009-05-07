Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbZEGU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbZEGU6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZEGU6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:58:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbZEGU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:58:36 -0400
Date: Thu, 7 May 2009 13:51:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, borislav.petkov@amd.com
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-Id: <20090507135102.dc4f93b0.akpm@linux-foundation.org>
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 15:49:22 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> here's v3 of the EDAC module for AMD k8, Fam10h and Fam11h processors.
> Among the changes from the previous version are a split of the
> driver into several .c files based on functionality, removal of
> StinkyIdentifiers and bunch of cleanups all over the place.
> 
> Thanks again to all the reviewers for their constructive comments, as
> always give it a good stare and flame away :).
> 
> There's also a git repo with the patchset based on Linus' branch from
> yesterday:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/amd64_edac.git

Seeing as you have a git tree and I'm always happy to avoid work, I'd
suggest that you ask Stephen Rothwell to inlude this drivee in
linux-next and then ask Linus to pull it during the 2.6.31-rc1 merge
window.

That does put an onus upon you to ensure that any changes which you
make to your tree between now and then are suitably reviewed, please.

