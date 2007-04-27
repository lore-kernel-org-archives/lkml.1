Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXD0XQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXD0XQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbXD0XQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:16:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298AbXD0XQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:16:09 -0400
Message-ID: <4632842F.20101@zytor.com>
Date: Fri, 27 Apr 2007 16:15:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <46313F99.6080402@zytor.com> <46314A08.9000209@redhat.com> <46314AAD.9010300@zytor.com> <46314C3B.3040908@redhat.com>
In-Reply-To: <46314C3B.3040908@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> H. Peter Anvin wrote:
>> Primarily to let a backup program restore the full state of the filesystem.
> 
> Is this wanted?  Or needed?  I would think there are good reasons why
> this hasn't been done so far.  Intrusion detection is one reason I can
> think of.

Well, dump/restore -- the traditional Unix backup solution -- went "the
back way" to restore the times in the filesystem.

The main use of atime seems to be to figure out when something can be
automatically deleted.  Anyone else have other usage scenarios?

	-hpa

