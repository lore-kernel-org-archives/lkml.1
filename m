Return-Path: <linux-kernel-owner+w=401wt.eu-S1030980AbXECJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030980AbXECJk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXECJk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:40:57 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030980AbXECJk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:40:56 -0400
Date: Thu, 3 May 2007 02:40:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glen Turner <gdt@gdt.id.au>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting process death for anycast named process monitoring
Message-Id: <20070503024048.e7192b3b.akpm@linux-foundation.org>
In-Reply-To: <4638FCEA.4010806@gdt.id.au>
References: <4638FCEA.4010806@gdt.id.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 06:34:42 +0930 Glen Turner <gdt@gdt.id.au> wrote:

> The question is, how can a process with no relationship to another
> process detect that process unexpectedly dying?

Monitor the system using the taskstats interface.  There is a sample
application and documentation in Documentation/accounting/.

Your monitoring application will receive a netlink packet each time a process
exits.  It includes the exit code and the process's name.
