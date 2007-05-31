Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbXEaE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbXEaE5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXEaE5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:57:07 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbXEaE5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:57:05 -0400
Date: Wed, 30 May 2007 21:56:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section mismatches
Message-Id: <20070530215631.bb847429.akpm@linux-foundation.org>
In-Reply-To: <20070531045033.GB20795@uranus.ravnborg.org>
References: <20070530180217.bebfa4b0.akpm@linux-foundation.org>
	<20070531045033.GB20795@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 06:50:33 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> Is it correct assumed that start_kernel() is never called in the HOTPLUG case since we
> are dealign with CPU #2 and more?

start_kernel is called once, on the boot CPU, before the other CPUs are
brought up.
