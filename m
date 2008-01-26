Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbYAZCsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbYAZCsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 21:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYAZCsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 21:48:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:41123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYAZCsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 21:48:40 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Q: x86 suspend/hibernation code consolidation
Date: Fri, 25 Jan 2008 21:47:26 -0500
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <200801260132.09529.rjw@sisk.pl>
In-Reply-To: <200801260132.09529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801252147.27254.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 19:32, Rafael J. Wysocki wrote:
> Hi,
> 
> I'd like to move the 64-bit suspend/hibernation files from arch/x86/kernel to
> arch/x86/power, modify the names of the 32-bit files already in
> arch/x86/power and update the Makefiles accordingly, but there are some changes
> queued for merging that touch the files in question.
> 
> When is the right time for making changes like that?
> 
> Rafael

In Cambridge, when we discussed cleanups that touch a lot of files
but have no functional change -- somebody suggested that right
after rc1 closes is a good time.  The reasoning was that they
would not conflict with the functional changes in rc1.

However, I recall Linus saying something about "Andrew is special"
WRT permission to push cleanups after the rc1 window; so I don't
know what the final ruling was -- if there was such a ruling.

-Len
