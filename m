Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYK3Hmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYK3Hmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 02:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYK3Hmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 02:42:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbYK3Hmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 02:42:35 -0500
Date: Sat, 29 Nov 2008 23:42:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mierswa <impulze@impulze.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Fujitsu Amilo PA 1510 key-release events quirk
Message-Id: <20081129234230.86730f14.akpm@linux-foundation.org>
In-Reply-To: <20081129233826.be959cae.akpm@linux-foundation.org>
References: <4931BB48.9010706@impulze.org>
	<20081129233826.be959cae.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 23:38:26 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> Just write a C function:
> 
> void atkbd_gen_release_event(unsigned int *keys, unsigned nr_keys)

                               ^ const

> {
> 	...
> }
> 
> 
