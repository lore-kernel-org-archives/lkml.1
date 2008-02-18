Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYBRO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYBRO2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYBRO2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:28:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYBRO17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:27:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
References: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be> <47B70A61.9030306@tiscali.nl> <20080216092552.325e5726@laptopd505.fenrus.org> <20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org> <47B72BFE.9060302@am.sony.com> <20080216103927.2a02352b@laptopd505.fenrus.org> <1203249003.6718.24.camel@concordia> <20080218135609.GD21080@cs181133002.pp.htv.fi> 
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: dhowells@redhat.com, Adrian Bunk <bunk@kernel.org>,
       Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>,
       cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       Willy Tarreau <w@1wt.eu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 18 Feb 2008 14:27:10 +0000
Message-ID: <12131.1203344830@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Hence shouldn't we ask the gcc people what's the purpose of
> __builtin_expect(), if it doesn't live up to its promise?

__builtin_expect() is useful on FRV where you _have_ to give each branch and
conditional branch instruction a measure of probability whether the branch
will be taken.

David
