Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZBISfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZBISfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBISe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:34:57 -0500
Received: from gw.goop.org ([64.81.55.164]:50624 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZBISe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:34:56 -0500
Message-ID: <4990774E.5080206@goop.org>
Date: Mon, 09 Feb 2009 10:34:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 08/11] x86: use asm .macro instead of cpp #define in entry_32.S
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-9-git-send-email-tj@kernel.org>
In-Reply-To: <1234186798-16820-9-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: cleanup
>
> Use .macro instead of cpp #define where approriate.  This cleans up
> code and will ease future changes.
>   

I agree with this in principle - cpp macros are indeed very ugly - but 
in practise I've found asm macros to be very hard to work with.  When 
things go wrong, the gas error messages are completely useless (it only 
reports the error on the line where the macro was used, without any 
detail about where in the macro the problem lies), and as far as I know, 
there's no way to see the source with macros expanded.

    J
