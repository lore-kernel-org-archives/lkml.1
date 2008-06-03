Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYFCTcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYFCTcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYFCTcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:32:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009AbYFCTc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:32:29 -0400
Date: Tue, 3 Jun 2008 12:32:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, nix@esperi.org.uk
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-Id: <20080603123211.e129c222.akpm@linux-foundation.org>
In-Reply-To: <20080603190235.GA9511@c2.user-mode-linux.org>
References: <20080603190235.GA9511@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 15:02:35 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> Protection against the host's time going backwards - keep track of the
> time at the last tick and if it's greater than the current time, keep
> time stopped until the host catches up.

Strange.  What would cause the host's time (or at least UML's perception
of it) to go backwards?
