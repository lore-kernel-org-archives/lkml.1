Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbZFCPYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbZFCPYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZFCPXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:23:53 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36845 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755266AbZFCPXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:23:53 -0400
Date: Wed, 3 Jun 2009 11:23:47 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906031121030.15621@gentwo.org>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com>
 <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Linus Torvalds wrote:

> The point being that we do need to support mmap at zero. Not necessarily
> universally, but it can't be some fixed "we don't allow that".

Hmmm... Depend on some capability? CAP_SYS_PTRACE may be something
remotely related?

