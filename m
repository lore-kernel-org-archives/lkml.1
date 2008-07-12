Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYGLXAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYGLXAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYGLXAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:00:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:45019 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYGLXAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OZ0w8Kuaaozv4QcsSlpHPODlkxLkLH+jKZhxWjTIRRFMnFNUHTS3pru4xxYfpWIdxd
         O4LX3ukXJenptKwNfY3oNzF8eCB0XHrfRnmdrghCcbDpbFnvAQsQOMRaQuOeygqUriCd
         AIz59HMxRxG83WGm5F6Ubne3oGXmT4NWpSCVE=
Message-ID: <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
Date: Sun, 13 Jul 2008 01:00:30 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O Master Penguin,

On Sun, Jul 13, 2008 at 12:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Assuming I didn't do anythign stupid, of course, which is why it would
> definitely need much more testing. And especially if Vegard can test it
> with the case that oopsed for him due to the bad migration..

Your patch has been tested and found to be working!

It was applied on top of latest linux-2.6.git with the right config
and passed all my tests, including the bad test-case.

(A little pet horse for the occasion: Testing can show the presence of
errors, but not their absence. But that's a different story.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
