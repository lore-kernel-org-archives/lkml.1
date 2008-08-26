Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYHZKne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYHZKne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYHZKn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:43:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:10390 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbYHZKnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MrWC8e6CSJjXEUollSFaljoWoG4q5hdzzt3YKcPIzpBegsFDhD5XxutECma53VR4Ub
         IyFzXVmfiJL2qWQTmwaqCrfoOIwnGaM12z2C8ALRgjCKg9+jNnL6LBIT6GGjOPGF+VG2
         sEEwlxOp99yVvQ8i8uFubEfDLuafrwj4Qwlbs=
Date: Tue, 26 Aug 2008 14:44:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jassi_singh_brar@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
Message-ID: <20080826104454.GA13455@x200.localdomain>
References: <801995.65435.qm@web33201.mail.mud.yahoo.com> <87tzd89oap.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzd89oap.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 10:24:30AM +0200, Andi Kleen wrote:
> jassi brar <jassi_singh_brar@yahoo.com> writes:
> 
> >   Lately a question has been bugging me: Why do we keep complicated(specific ioctls to set up and set free) 
> 
> Can you please expand a bit why you think losetup is that complicated
> and what the problem is with it?
> 
> AFAIK you're essentially just moving a minimal version of losetup
> (with missing features like no offsets etc.) into the kernel and
> frankly I fail to see the beauty in that. Or rather if you start with
> losetup, why stop at mount, modprobe, ifconfig, mkfs, fsck, ls[1], ...?
> 
> For me it seems more that most of the file system based command
> interfaces (/proc/mtrr comes to mind) are quite hard to use

Name four.

> and I prefer a proper command line tool with a manpage and --help
> and a real parser any day.

Go write mtrrctl(1) and a manpage. You'll need it in case of
ioctl-based interface anyway.

