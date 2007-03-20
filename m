Return-Path: <linux-kernel-owner+w=401wt.eu-S1030819AbXCTBDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbXCTBDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966059AbXCTBDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:03:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbXCTBDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:03:40 -0400
Date: Mon, 19 Mar 2007 18:02:25 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: chrdev_open lifetime question
Message-Id: <20070319180225.4638bc80.zaitcev@redhat.com>
In-Reply-To: <d120d5000703071423n11ade9d7n1852296d70b53d62@mail.gmail.com>
References: <d120d5000703071423n11ade9d7n1852296d70b53d62@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 17:23:05 -0500, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> It seems that if a process keeps a character device open then other
> processes will also be able to get into filp->f_op->open(inode,filp)
> in chrdev_open() even after a driver called cdev_del() as part of its
> unwind procedure. Is this correct or am I missing something?

I see no replies in the archives. Have you got any private ones?

Also, what's the context?

-- Pete
