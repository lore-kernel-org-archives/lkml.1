Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZKNDsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZKNDsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbZKNDsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:48:08 -0500
Received: from mail.perches.com ([173.55.12.10]:1053 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbZKNDsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:48:07 -0500
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
From: Joe Perches <joe@perches.com>
To: David Wagner <daw-news@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <hdl92e$srv$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
	 <4AFCC06B.1030302@schaufler-ca.com>
	 <19857.1258147396@turing-police.cc.vt.edu>
	 <4AFE1EA9.60102@schaufler-ca.com>  <hdl92e$srv$1@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 19:48:11 -0800
Message-ID: <1258170491.16857.142.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-14 at 03:44 +0000, David Wagner wrote:
> I personally don't find
>     strncmp(foo, "constant", sizeof("constant"))        // first snippet
> to be more readable, auditable, or obviously correct than
>     strcmp(foo, "constant").                            // second snippet
> Is there a technical basis for arguing that the first
> snippet is better than the second snippet?

I don't think there is.

