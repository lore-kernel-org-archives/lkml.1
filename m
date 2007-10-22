Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbXJVJML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbXJVJML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXJVJL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:11:57 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:42964 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXJVJL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:11:56 -0400
Date: Mon, 22 Oct 2007 11:11:52 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 100% iowait on one of cpus in current -git
Message-ID: <20071022111152.12ca0425@localhost>
In-Reply-To: <200710220822.52370.maximlevitsky@gmail.com>
References: <200710220822.52370.maximlevitsky@gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 08:22:52 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> I tried to bisect this, but eventually I run into other bugs that cause system to oops early.

You can pick a different revision to test with:
	git-reset --hard  "SHA1"

Choose one with "git-bisect visualize".

-- 
	Paolo Ornati
	Linux 2.6.23-ge8b8c977 on x86_64
