Return-Path: <linux-kernel-owner+w=401wt.eu-S1765422AbXJSQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765422AbXJSQxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757711AbXJSQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:53:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbXJSQx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:53:29 -0400
Date: Fri, 19 Oct 2007 09:53:13 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Vitaliy Ivanov" <vitalivanov@gmail.com>
Cc: w@1wt.eu, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-Id: <20071019095313.76990765.zaitcev@redhat.com>
In-Reply-To: <35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	<20071014182542.GA2832@1wt.eu>
	<35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	<20071014223921.GA4677@1wt.eu>
	<1192542889.29039.66.camel@dell1.softservecom.com>
	<20071016154138.GA23326@1wt.eu>
	<1192559051.29039.139.camel@dell1.softservecom.com>
	<1192644776.10761.60.camel@dell1.softservecom.com>
	<35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 18:26:35 +0300, "Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:

> Didn't here anything on this? What is our final decision here?

It's gotten worse, not better. Apparently, you aren't getting the
concept of protecting the open count with a static lock and my
explanations are just not vivid enough or something. So I decided
to fix it myself. Maybe then the patch in C will explain it better
than English. But I didn't have time to do it.

Also, there's an outright bug in the latest version. Your purge
of the wrong lock was incomplete and so there was an unbalanced up().
But this is moot.

So, the version before the latest is borderline acceptable. If Willy
wants to take it, it's fine. I'll fix it up later together with 2.6.

-- Pete
