Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYCFSfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYCFSfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYCFSfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:35:22 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:3663 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYCFSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XQMSAq+h1dXj8XU4c+ShoZnTF8tXpakkp97qZhMUWIZsxXN6P1dGCUWWE5h5yqv+po3wAZquZi1yRY0MTwhEhS2l6C7HdShcPDhv4D9gjypYdOUMp5p4EgiAV06HBz6r8oaN8hrOY1EulHFJ0ykZPNKy6/QpYD4VcihNAkYzC/U=
Message-ID: <de8d50360803061035w31622950lfc0cdcfb94b8ea34@mail.gmail.com>
Date: Thu, 6 Mar 2008 10:35:13 -0800
From: "Andrew Pinski" <pinskia@gmail.com>
To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080306183146.GL27983@randombit.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>
	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>
	 <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org>
	 <20080306175841.GI17267@synopsys.com>
	 <20080306181029.GA42904@dspnet.fr.eu.org> <47D03440.6090503@gnu.org>
	 <20080306183146.GL27983@randombit.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/08, Jack Lloyd <lloyd@randombit.net> wrote:
> On Thu, Mar 06, 2008 at 07:13:20PM +0100, Paolo Bonzini wrote:
>  > A process can send a signal via kill.  IOW, a malicious process can
>  > *control when the process would be interrupted* in order to get it into
>  > the signal handler with DF=1.
>
>  If the malicious process can send a signal to another process, it
>  could also ptrace() it. Which is more useful, if you wanted to be
>  malicious?

And more to the point, it can happen before GCC 4.3.0.  So why does
GCC have do something that just happens more often now?  I still don't
see why we have to work around a bug in the kernel which could show up
before GCC 4.3.0.

-- Pinski
