Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbYA0WtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbYA0WtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYA0Wsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:48:52 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:33636 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbYA0Wsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dsrWRkWafp5S0fLMRnlMSCYqzkiD9mcqthIXH2cH4JQ6q3729W6zNx1lq9b3otna+TiD59jC4NZH7x3zZ0Bqalf885zqZvg8rvWvErbdSI8YplttF35DOI9MQixq+xVSwTxpe27O8NgPY6HFXfWVcedO9JKxBxcAfbiQ1kyqyYY=
Message-ID: <4d8e3fd30801271448ja6a44ferbf86d37c2f3b825@mail.gmail.com>
Date: Sun, 27 Jan 2008 23:48:48 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c - take 2
Cc: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080127224258.GA22018@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127231527.2ea40804@paolo-desktop>
	 <479D067E.3010100@gmail.com> <20080127224258.GA22018@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
>
> > Looks like it would be better to proceed in the following manner:
> >
> > 1) remove dead code (no md5 change);
> > 2) reformat the lines to use tabs, not spaces (no md5 change);
> > 3) address the "else-braces" and "single statement block" errors
> >    (no md5 change);
> > 4) remove all unnecessary spaces (no md5 change);
> > 5) add the KERN_ macros (md5 will change).
> > 6) address remaining checkpatch complaints (no md5 change wrt #5
> >    above).
> >
> > Each item above might get into a separate patch.
>
> agreed, that looks like a sensible splitup for such larger cleanup
> patches.
>
> (also, a debug switch that disabled the FPU on modern CPUs and which
> forced math-emu would be nice as well.)

OK, I'll do what you both suggested.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
