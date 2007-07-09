Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXGIKfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXGIKfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXGIKfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:35:45 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:36030 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbXGIKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:35:45 -0400
Date: Mon, 9 Jul 2007 11:27:55 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/asm-mips/processor.h: "extern inline" ->
	"static inline"
Message-ID: <20070709102754.GB24487@linux-mips.org>
References: <20070707010330.GY3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707010330.GY3492@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 03:03:30AM +0200, Adrian Bunk wrote:

> "extern inline" will have different semantics with gcc 4.3,
> and "static inline" is correct here.

The idea was to have a linker error in case gcc should deciede for some
reason not to inline this function which as I understand will continue
to be the behaviour of gcc 4.3?

  Ralf
