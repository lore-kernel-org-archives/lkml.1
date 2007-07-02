Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbXGBUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbXGBUOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbXGBUOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:14:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbXGBUOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:14:06 -0400
Message-ID: <46895C76.5090702@redhat.com>
Date: Mon, 02 Jul 2007 16:13:42 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, zwane@infradead.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>
In-Reply-To: <4686D85B.6090803@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2007 06:25 PM, Daniel Drake wrote:
> Jan Beulich wrote:
>> The code to retrieve this information was (a) inside a
>> CONFIG_VIDEO_SELECT
>> section and (b) protected by a check of a variable (vbe_version) that
>> would get initialized only when a VESA mode was selected on the command
>> line.
> 
> This patch solves a 2.6.20.11 (and 2.6.21) regression added by the patch
> titled "x86: Don't probe for DDC on VBE1.2"
> 
> The regression caused the screen resolution to be incorrectly adjusted
> by 6 pixels. This patch makes it go back to normal again.
> 
> https://bugs.gentoo.org/show_bug.cgi?id=181067
> 
> 

Well, that explains this too I'd guess:

	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=245741


