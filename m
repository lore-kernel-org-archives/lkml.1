Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbXK0Ebi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbXK0Ebi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXK0Eba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:31:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbXK0Eb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:31:29 -0500
Date: Mon, 26 Nov 2007 20:31:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: andrew.patterson@hp.com
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Error returns not handled correctly by
 sysfs.c:subsys_attr_store()
Message-Id: <20071126203116.0c93cdb9.akpm@linux-foundation.org>
In-Reply-To: <1195683419.16019.225.camel@grinch>
References: <1195683419.16019.225.camel@grinch>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 15:16:59 -0700 Andrew Patterson <andrew.patterson@hp.com> wrote:

> The buf in fs/sysfs.c:subsys_attr_store() does not seem to be updated
> correctly when returning a negative value (indicating that an error
> condition has occurred) is returned.  If a negative value is returned,
> the next subsequent call to subsys_attr_store will have the contents of
> buf appended to the previous call.

subsys_attr_store() gets deleted by
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kset-kill-subsys-attr.patch

So maybe we will soon accidentally fix whatever-this-is?  Or maybe we will
faithfully maintain it.
