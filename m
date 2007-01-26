Return-Path: <linux-kernel-owner+w=401wt.eu-S1030649AbXAZOgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649AbXAZOgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXAZOgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:36:04 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:58794 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030658AbXAZOgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:36:03 -0500
Date: Fri, 26 Jan 2007 06:35:55 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: Stephane Eranian <eranian@hpl.hp.com>
Subject: i386 and x86-64 bitops function prototypes differ
Message-ID: <20070126143555.GL11525@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I ran into compiler warnings with the perfmon code when I tried
using test() and __set_bit() on i386. 

For some reason, the i386 bitops functions use unsigned long * for
the address whereas x86-64/ia64 use void *.

I do not quite understand why such difference?
Is this just for historical reasons?

Thanks.

-- 
-Stephane
