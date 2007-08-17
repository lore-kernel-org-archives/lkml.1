Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbXHQVJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbXHQVJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXHQVJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:09:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755901AbXHQVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:09:34 -0400
Date: Fri, 17 Aug 2007 14:08:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm] x86_64: Save registers in saved_context during
 suspend and hibernation
Message-Id: <20070817140820.63c22071.akpm@linux-foundation.org>
In-Reply-To: <200708171526.23250.rjw@sisk.pl>
References: <200708171526.23250.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 15:26:22 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> During hibernation and suspend on x86_64 save CPU registers in the saved_context
> structure rather than in a handful of separate variables.

You have "-mm" in the subject but afaict this patch is not dependent upon
anything in -mm?

