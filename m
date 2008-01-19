Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYASFNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYASFNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYASFM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:12:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:39150 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYASFMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rPw2iFnNrTXH6ZgoAdD4yh0cC+9pP6Yj5CW8Y1xc9ihWnSVtVZGmXFec/hNo952CxiXZhxTuJudm9ir4QVp2jNkOF9v7oiVdADCi+cW+2/dlZ3WnUMZKC91nz400iLKhc/Gid7pwhrVezPjW+6mvD93CAXx2QJhf6eN1ki7bwCg=
Subject: Re: [PATCH] x86: Unify printk strings in fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200801190608.42452.ak@suse.de>
References: <1200716549.5724.150.camel@brick>
	 <200801190608.42452.ak@suse.de>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 21:12:56 -0800
Message-Id: <1200719576.5724.157.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-19 at 06:08 +0100, Andi Kleen wrote:
> On Saturday 19 January 2008 05:22:29 Harvey Harrison wrote:
> > Adding the address of the faulting library missed removing a
> > line ending from X86_32.
> > 
> > Also update the shorter printk format for X86_32 in fault_64.c
> > to make it easier to se the remaining differences.
> 
> Thanks. I think it was correct initially, but one of the merge steps
> with the changing git-x86 caused some hunks to be dropped and the patch 
> never quite recovered from that.

No worries, hoping to get them unified this weekend, should make this
easier going forward.

Harvey

