Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYF1EM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYF1EM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYF1EMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:12:18 -0400
Received: from ozlabs.org ([203.10.76.45]:42991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYF1EMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:12:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "nkalmala@gmail.com" <nkalmala@gmail.com>
Subject: Re: [patch] experimental: try-resolve-unexported-symbol-references-in-modules
Date: Sat, 28 Jun 2008 14:11:55 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <4864DFD2.60508@gmail.com>
In-Reply-To: <4864DFD2.60508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806281411.56263.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008 22:40:50 nkalmala@gmail.com wrote:
> For purely experimental purposes, let the kernel resolve unexported-symbol
> references in external modules when loading them. Iff used carefully, this
> helps save time on development cycles. building testing experimenting
> certain kinds of changes becomes really fast.

This is unlikely to ever get into the tree.  And that's OK: AFAICT you can do 
it without any core kernel changes, by building a module which exports the 
symbols you need.

Cheers,
Rusty.
