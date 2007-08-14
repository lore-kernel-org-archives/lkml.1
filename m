Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXHNWvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXHNWvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXHNWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:51:16 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:57837 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbXHNWvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:51:15 -0400
Date: Tue, 14 Aug 2007 15:51:14 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Thinking outside the box on file systems
In-Reply-To: <106259.96671.qm@web52501.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Marc Perkel wrote:

> For example. If you list a directory you only see the
> files that you have some rights to and files where you
> have no rights are invisible to you. If a file is read
> only to you then you can't delete it either. Having
> write access to a directory really means that you have
> file create rights. You can also delete files that you
> have write access to. You would also allocate
> permissions to manage file rights like being able to
> set the rights of inferior users.

Imagine the fun you will have trying to write a file name and being told 
you cannot write it for some unknown reason.  Unbeknownst to you, there is 
a file there, but it is not owned by you, thus invisible.

Making a file system more user oriented would avoid little gotchas like 
this.  The reason it is "programmer oriented" is that those are the people 
who have worked out why it works and why certain things are bad ideas.

-- 
Refrigerator Rule #1: If you don't remember when you bought it, Don't eat it.
