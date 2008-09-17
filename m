Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYIQXGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYIQXGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYIQXGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:06:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbYIQXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:06:05 -0400
Date: Wed, 17 Sep 2008 16:06:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib: pull base-guessing logic to helper function
Message-Id: <20080917160603.2f869a26.akpm@linux-foundation.org>
In-Reply-To: <1221675722.7298.4.camel@brick>
References: <1221675722.7298.4.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 11:22:02 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> There is a small behavior change in this patch, previously, when
> no base was specified and the string began with 0x? the base would
> be guessed as 8, unless isxdigit(?) was true.  This would then return
> 0 as 'x' was larger than 8.  Now, the base is always guessed as 16 if
> the string starts with '0x'

hm.  I'd call that a bugfix.
