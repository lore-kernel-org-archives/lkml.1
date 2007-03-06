Return-Path: <linux-kernel-owner+w=401wt.eu-S1030344AbXCFJ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344AbXCFJ6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXCFJ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:58:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:55074 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030344AbXCFJ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:58:05 -0500
Message-ID: <45ED3A8D.9090906@argo.co.il>
Date: Tue, 06 Mar 2007 11:55:25 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de>
In-Reply-To: <45ED3121.8090308@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Oh, and btw:  What was the reason why kvm paravirtualization doesn't use
> the vmi interface?
>
>   

There actually was proof of concept code to do just that (by Anthony 
Liguori).  For Linux, I feel paravirt_ops is superior as we can extend 
it if something is missing.  If VMI is adopted by non-Linux guests, we 
may support it as a quick way to add paravirt support for those guests.

-- 
error compiling committee.c: too many arguments to function

