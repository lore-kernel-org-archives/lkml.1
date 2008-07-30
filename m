Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbYG3Jf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbYG3Jf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYG3JfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:35:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbYG3JfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:35:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200807300907.25186.arnd@arndb.de>
References: <200807300907.25186.arnd@arndb.de> <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dhowells@redhat.com, Greg Ungerer <gerg@snapgear.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 30 Jul 2008 10:34:55 +0100
Message-ID: <3995.1217410495@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> I think the more interesting aspect in m68knommu is what happens
> when asm-m68k gets moved. Does that work as well?

Can m68knommu be merged into m68k and be made contingent on CONFIG_MMU?  This
is what FRV does.

David
