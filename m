Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbYCWLLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbYCWLLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbYCWLKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:10:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31287 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbYCWLKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iv6xIKYXTAP6xAfLfVyv9co2eqbnDelgpzkccR/XgBy3cwARtAmsGCe8DQERUgFXPaOutHmrefOdS6oC3Z6Q8/XrnWzH5b6xXxYReYk35t3Ryr0/IyghpvcvW+BiyNZVw7J66BfD9LqTlRTOzEnB/zvAst14DQ0Cqy1hJygmsE8=
Date: Sun, 23 Mar 2008 14:10:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86 - relocate_kernel cleanup
Message-ID: <20080323111017.GA7612@cvg>
References: <20080322210005.117475478@gmail.com> <47E576B9.6090205@zytor.com> <47E577B9.1010403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E577B9.1010403@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sat, Mar 22, 2008 at 02:18:49PM -0700]
> H. Peter Anvin wrote:
>> gorcunov@gmail.com wrote:
>>> The main purpose of this patches is to eliminate numeric constant and
>>> use predefined macroses. Please review. I've tested 64bit version on
>>> object level - it remains the same. Any comments are welcome.
>> Looks good.  Since you're doing work in this realm, you may also want to 
>> replace the old TF_MASK etc macros with X86_EFLAGS_TF etc.
>
> That wasn't meant to be a comment specific to the relocate_kernel stuff, 
> incidentally.
>
> 	-hpa
>

You know, Peter, I'm a bit scared that these flags are in number
of files and could break others queued patches...

		- Cyrill -
