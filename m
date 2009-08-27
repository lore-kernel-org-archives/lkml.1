Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbZH0TPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbZH0TPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZH0TPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:15:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:13487 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZH0TPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VPyZwy/dKYcCKLnMo0WNqTl6WAEfOv8JczAJczc9cfdc47gkjNmzbGZptF9FFwrIkV
         wdclp/XP/BOxfI1ttmqa3P8HBzHkwj93/b9SUNOmcp959dUBBC/sy8B9ZQW5YnQEO5V0
         fgpcRamMybZMbXkacFpdFPbE6/LOD5v9gPMSM=
MIME-Version: 1.0
In-Reply-To: <082720091839.15057.4A96D2D10002C02000003AD122230647029B0A02D2080C0A9B079D0A030EBF9F030E059B070A08@att.net>
References: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org> 
	<m3prahctv6.fsf@hase.home> <082720091839.15057.4A96D2D10002C02000003AD122230647029B0A02D2080C0A9B079D0A030EBF9F030E059B070A08@att.net>
From: Ulrich Drepper <drepper@gmail.com>
Date: Thu, 27 Aug 2009 12:15:12 -0700
Message-ID: <a36005b50908271215v27f06476p5808b9fb6b19fa81@mail.gmail.com>
Subject: Re: popen2 popen call
To: heitkamp@ameritech.net
Cc: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:39, <heitkamp@ameritech.net> wrote:
> OK.  I read in one of the messages, that glibc, passes the popen call to a ABI in the kernel. I have not
> looked at the code in glibc yet.

popen uses pipe2.  There is fallback code to use pipe if necessary.
It's compiled out only of the libc assumes the kernel support is
available.
