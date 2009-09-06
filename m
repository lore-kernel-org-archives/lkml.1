Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZIFWFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZIFWFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 18:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZIFWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 18:05:52 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:41071 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZIFWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 18:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
Date: Sun, 6 Sep 2009 17:59:10 -0400
Message-ID: <7e0fb38c0909061459m4c1bc252kd7ec25db08f0f3a3@mail.gmail.com>
Subject: Re: [PATCH] IMA: update ima_counts_put
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Ciprian Docan <docan@eden.rutgers.edu>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 1:08 PM, Mimi Zohar<zohar@linux.vnet.ibm.com> wrote:
> - As ima_counts_put() may be called after the inode has been freed,
> verify that the inode is not NULL, before dereferencing it.
>
> - Maintain the IMA file counters in may_open() properly, decrementing
> any counter increments on subsequent errors.

This is a 2.6.31 regression introduced in 94e5d714f604d4cb4cb13

James can you push it along?

Acked-by: Eric Paris <eparis@redhat.com
