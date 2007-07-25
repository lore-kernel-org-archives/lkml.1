Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbXGYEOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbXGYEOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXGYEOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:14:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45447 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXGYEOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:14:09 -0400
Date: Wed, 25 Jul 2007 05:14:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: rae l <crquan@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Message-ID: <20070725041407.GA27237@ftp.linux.org.uk>
References: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 11:48:35AM +0800, rae l wrote:
> Why alloc_super use a static variable default_op?
> the static struct super_operations default_op is just all zeros, and
> just referenced as the initial value of a new allocated super_block,
> what does it for?

So that we would not have to care about ->s_op *ever* being NULL.
