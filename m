Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXCYFg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXCYFg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXCYFg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:36:28 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:1303 "EHLO
	asav12.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXCYFg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:36:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFqnBUZKhRO4dGdsb2JhbACPYQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: chrdev_open lifetime question
Date: Sun, 25 Mar 2007 01:36:25 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <d120d5000703071423n11ade9d7n1852296d70b53d62@mail.gmail.com> <20070319180225.4638bc80.zaitcev@redhat.com>
In-Reply-To: <20070319180225.4638bc80.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703250136.26041.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On Monday 19 March 2007 21:02, Pete Zaitcev wrote:
> On Wed, 7 Mar 2007 17:23:05 -0500, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> 
> > It seems that if a process keeps a character device open then other
> > processes will also be able to get into filp->f_op->open(inode,filp)
> > in chrdev_open() even after a driver called cdev_del() as part of its
> > unwind procedure. Is this correct or am I missing something?
> 
> I see no replies in the archives. Have you got any private ones?

No I have not.

> 
> Also, what's the context?

I want to switch input handlers to cdevs to rip table of devices out
of input core and lift limit on potential number of devices and was
pondering locking implications.

-- 
Dmitry
