Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZA0UDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZA0UDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZA0UCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:02:54 -0500
Received: from mathups.math.u-psud.fr ([129.175.52.4]:39161 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755728AbZA0UCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:02:53 -0500
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 15:02:53 EST
From: Duncan Sands <baldrick@free.fr>
To: llvmdev@cs.uiuc.edu
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller 
 =?iso-8859-1?q?than=09input?=
Date: Tue, 27 Jan 2009 20:42:56 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com> <20090124172758.GA31699@elte.hu>
In-Reply-To: <20090124172758.GA31699@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901272042.57272.baldrick@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> If yes then this doesnt look all that bad or invasive at first sight (if 
> the put_user() workaround can be expressed in a cleaner way), but in any 
> case it would be nice to hear an LLVM person's opinion about roughly when 
> this is going to be solved in LLVM itself.

one thing that seems to be clear to everyone except me is... what are the
semantics supposed to be?  [My understanding is that what is being discussed
is when you have an asm with a register as input and output, but with integer
types of different width for the input and output, but I saw some mention of
struct types in this thread...].  Presumably this is something obvious, but
it would be good to have someone spell it out in small words that even someone
like me can understand :)

Thanks,

Duncan.
