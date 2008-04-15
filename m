Return-Path: <linux-kernel-owner+w=401wt.eu-S1765672AbYDOUG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765672AbYDOUG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbYDOUGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:06:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbYDOUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:06:47 -0400
Date: Tue, 15 Apr 2008 13:05:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: padlock-aes.c replace private copy of bit
 rotation routines
Message-Id: <20080415130541.4123b8a3.akpm@linux-foundation.org>
In-Reply-To: <1208286963.11920.90.camel@brick>
References: <1208286963.11920.90.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 12:16:03 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use the generic kernel implementation of the bit-rotation routines.
> The generic routines to not shift by mod 32, but all callers in the
> file pass constant values less than 32 making this a non-issue.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/crypto/padlock-aes.c |   19 +++----------------

git-cryptodev.patch has taken a big chainsaw to the code which you're
patching.

