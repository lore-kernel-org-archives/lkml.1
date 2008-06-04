Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbYFDTnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbYFDTnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762447AbYFDTmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:42:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:37483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762445AbYFDTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lp1Faducmz2GAcm5O3wdCi9Sf6NnXO5r2ATq5CWe9JXP/F9oBDo1If6le6uCG9TXBq
         XiApTRRUINSxe57DT5yjb5JtBMy6ytOeN/qO0HF6t1CYMUP4rCvRz1X5I5gLCIUrnh+W
         ecPWjohgYX9jLM9ZWx99k+MH2WQNZz++CIMCo=
Date: Wed, 4 Jun 2008 21:42:30 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, linux-tiny <Linux-tiny@selenic.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
Message-ID: <20080604194230.GE27768@mx.loc>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4846E44A.1010601@am.sony.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 11:51:54AM -0700, Tim Bird wrote:

>There are diminishing returns here, and at some point it doesn't make
>sense to continue.  I have a nagging feeling, though, that there
>are a few more things where the bloat is pronounced (glances at
>procfs and sysfs).

A decision on what to favour would certainly help: sysfs or ioctl or
something else.

While i have missed that in this particular case¹) you apparently shall
read via sysfs and write via ioctl -- i thought that most could already
be written via sysfs which doesn't seem to be true -- it would be nice
to get rid of the devilish ioctl mid-term iff there is consensus about
it. The bridge is admittedly a vicarious corner case and probably
seldomly used anyway.

¹)
https://lists.linux-foundation.org/pipermail/bridge/2008-May/005839.html
