Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYD0Xt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYD0Xt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbYD0XtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:49:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:23456 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbYD0XtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YaiEU4vew7TYc6JDLZvYggYqRtG6WX5G9hMUMoZuYsfjrmn9p1drnWTRXmLoOxVZ+EKRX/LtsovVYmASHKBUMSR9HV84rmR9tSt6Z3XWAE5wdxYjKOz3+ELK4d2+LSjA47JV3qAREpv8KWe4JvLP3Nf/OV6nRoYj3Btc14lOeNM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Date: Mon, 28 Apr 2008 01:48:22 +0200
User-Agent: KMail/1.8.2
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com>
In-Reply-To: <20080427232317.GB103491721@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804280148.22358.vda.linux@googlemail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008 01:23, David Chinner wrote:
> > This patch reduces xfs_page_state_convert() stack usage by 16 bytes
> > by eliminating some local variables, and reducing the size
> > of scope for other locals.
> > 
> > Compile tested only.
> 
> Can you start testing your patches? if you are touching the writeback
> or allocator path, there's a pretty high barrier to having patches
> excepted, and testing them before is one of them. Go and download the

Its you who asked for patches. It's not like I decided
to nag you because I have nothing better to do. Actually,
my plate is pretty full with other things already.

> XFSQA suite from the xfs-cmds CVS tree on oss.sgi.com, and run your
> patches through it....


On Tuesday 22 April 2008 03:28, David Chinner wrote:
> Patches are welcome - I'd be over the moon if any of the known 4k
> stack advocates sent a stack reduction patch for XFS, but it seems
> that actually trying to fix the problems is much harder than
> resending a one line patch every few months....

So I went ahead and actually spend a good chunk of the week
trying to help you.

I believe that my patches were sufficiently well thought-out,
carefully implemented and reasonably tested (for a guy who
never used xfs, have no xfs partitions, and not exactly
planning to use xfs in the future).

> pretty high barrier to having patches accepted

I was honestly trying to help you. I am still willing
to do it, but at some point you have to carry some part
of a burden (maybe review and run testing?).

If you are not going to accept patches, why you are
accusing people of not sending them to you?
--
vda
