Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFPNsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFPNsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYFPNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:48:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbYFPNsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:48:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1213619214.26255.721.camel@pmac.infradead.org>
References: <1213619214.26255.721.camel@pmac.infradead.org> <1213565555.26255.522.camel@pmac.infradead.org> <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dhowells@redhat.com, Adrian Bunk <bunk@kernel.org>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: Re: [PATCH v2] export linux/a.out.h
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 16 Jun 2008 14:48:14 +0100
Message-ID: <9834.1213624094@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> Why _are_ there architectures which define ARCH_SUPPORTS_AOUT and have
> <asm/a.out.h> but don't support binfmt_aout, anyway? How does that make
> sense?

Maybe because some arches supported ELF with AOUT interpreters but not full
AOUT binaries?

David
