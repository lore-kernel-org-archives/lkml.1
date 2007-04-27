Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXD0Xl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXD0Xl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbXD0Xl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:41:58 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:57504 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757913AbXD0Xl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:41:57 -0400
Date: Fri, 27 Apr 2007 16:05:49 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
In-Reply-To: <4632842F.20101@zytor.com>
Message-ID: <Pine.LNX.4.63.0704271605010.10565@qynat.qvtvafvgr.pbz>
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> 
 <20070426162530.bc30a1bb.akpm@linux-foundation.org>  <46313F99.6080402@zytor.com>
 <46314A08.9000209@redhat.com>  <46314AAD.9010300@zytor.com>
 <46314C3B.3040908@redhat.com> <4632842F.20101@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, H. Peter Anvin wrote:

> The main use of atime seems to be to figure out when something can be
> automatically deleted.  Anyone else have other usage scenarios?

as a varient of this, I use it to help determine what files are actually needed 
when building a chroot sandbox.

David Lang
