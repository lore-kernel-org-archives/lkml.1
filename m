Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZLEXBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZLEXBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZLEXBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:01:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34099 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbZLEXBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:01:44 -0500
Date: Sat, 5 Dec 2009 23:01:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: mingo@redhat.com
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091205230149.GZ14381@ZenIV.linux.org.uk>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, another fun question in the same area: what enforces the virtual
aliasing rules for fremap.c stuff?  AFAICS, on VIPT architectures
we are asking for trouble there.  No?

Is there anything that would prevent an arbitrary page from file's
page cache from being mapped at any cache colours?
