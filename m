Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbXEXWzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbXEXWzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXEXWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:55:21 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbXEXWzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:55:19 -0400
Date: Thu, 24 May 2007 15:54:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <richard@openedhand.com>
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>,
       Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
Subject: Re: [RFC] LZO de/compression support - take 3
Message-Id: <20070524155428.55460e9c.akpm@linux-foundation.org>
In-Reply-To: <1180046482.12821.42.camel@localhost.localdomain>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	<0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	<4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	<624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	<4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	<1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
	<4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
	<726113DF-D952-401F-96EA-7A10B035604B@cam.ac.uk>
	<1180046482.12821.42.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 23:41:22 +0100
Richard Purdie <richard@openedhand.com> wrote:

> I'll not send a "rename to unsafe" patch for the LZO core until Andrew
> decides whether to drop the unsafe version entirely or not as per your
> patch. If he doesn't due to the potential use by the compressed cache
> people, I will send that patch.

I'd have thought that a 3% performance difference isn't worth worrying
about.  Especially when reclaiming that 3% costs an additional 500 lines
of pretty yukky code.
