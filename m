Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYGRUxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYGRUxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYGRUxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:53:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbYGRUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:53:24 -0400
Date: Fri, 18 Jul 2008 13:52:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Reiser <jreiser@BitWagon.com>
Cc: ntl@pobox.com, benh@kernel.crashing.org, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
Message-Id: <20080718135244.a8867700.akpm@linux-foundation.org>
In-Reply-To: <4880FDA1.9070307@BitWagon.com>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	<1216166331-14810-2-git-send-email-ntl@pobox.com>
	<1216276539.7740.309.camel@pasglop>
	<20080717000951.5f8cab37.akpm@linux-foundation.org>
	<20080717221932.GL9594@localdomain>
	<20080717154218.8981035c.akpm@linux-foundation.org>
	<487FD74C.4080603@BitWagon.com>
	<20080718182850.GO9594@localdomain>
	<4880FDA1.9070307@BitWagon.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 13:31:29 -0700
John Reiser <jreiser@BitWagon.com> wrote:

> Elsewhere, I've staked out use of a new AT_WINE_PRELOAD_INFO
> at 30.  Avoid that one, please. :-)

The reliable way in which to reserve these numbers is to patch the
header file.
