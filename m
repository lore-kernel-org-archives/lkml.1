Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYD2TXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYD2TXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYD2TXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:23:05 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:7398 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752877AbYD2TXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lnQJXio+f2FRSCgfkPmsImyUyFJmKeXgM46bmnsmPd8OD4x39SUwB62PAFB6EnEhExgA72npE/iHGnCrd3IHq/nNqb6XSXRe4KCrFw5/pNOwmHslzeHhEdwZCkUxeDG5kkNXQCEKaG/X+W7rcCA4y37rNe3lJkDiRRgvqoT7yJM=
Message-ID: <84144f020804291223x6e40509fk8461ed4d96d443b@mail.gmail.com>
Date: Tue, 29 Apr 2008 22:23:02 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [2/2] vmallocinfo: Add caller information
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0804291204450.12689@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318222701.788442216@sgi.com>
	 <20080318222827.519656153@sgi.com> <20080429084854.GA14913@elte.hu>
	 <Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
	 <20080428124849.4959c419@infradead.org>
	 <Pine.LNX.4.64.0804291143080.12128@schroedinger.engr.sgi.com>
	 <20080428140026.32aaf3bf@infradead.org>
	 <Pine.LNX.4.64.0804291204450.12689@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: b7a015a538953700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:09 PM, Christoph Lameter <clameter@sgi.com> wrote:
>  Well so we display out of whack backtraces? There are also issues on
>  platforms that do not have a stack in the classic sense (rotating register
>  file on IA64 and Sparc64 f.e.). Determining a backtrace can be very
>  expensive.

I think that's the key question here whether we need to enable this on
production systems? If yes, why? If it's just a debugging aid, then I
see Ingo's point of save_stack_trace(); otherwise the low-overhead
__builtin_return_address() makes more sense.

And btw, why is this new file not in /sys/kernel....?
