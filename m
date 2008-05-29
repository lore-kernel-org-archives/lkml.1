Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYE2LdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYE2LdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYE2LdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:04 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55752 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYE2LdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:01 -0400
Message-ID: <483E946B.8010908@aitel.hist.no>
Date: Thu, 29 May 2008 13:32:59 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
References: <1211995212.3445.52.camel@localhost.localdomain>
In-Reply-To: <1211995212.3445.52.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
[...]
> track down, the last thing I want to see within a million miles of my
> inbox is a white space fixing patch.  The more of these patches we get,
> the worse the problem becomes and the shorter and more inflammatory the
> responses get. We can't go on like this.
> 
This particular problem seems fixable. Put something like this in the 
janitor faq:

"Don't create patches that are whitespace-fixes, or similiar attempts to
make the kernel adhere to the CodingStyle without actually changing the 
working code. The reasons are:
* Any patch disturbs others working on the same file. So change must be
   justified by usefulness above mere pretty formatting.
* The maintainer can run the code through pretty-printing software
   _when it won't disrupt other activity_. Such software will do
   a better cleanup job than you can, and with no human effort at.
Please find something more useful to do than whitespace/style
improvements on existing code."

And if they do this anyway, just reject the patch with a pointer to the 
FAQ entry...

Helge Hafting

