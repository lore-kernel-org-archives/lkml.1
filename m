Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbZEGSGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbZEGSGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbZEGSGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:06:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50617 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZEGSGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:06:33 -0400
Message-ID: <4A0322F1.2000905@redhat.com>
Date: Thu, 07 May 2009 21:05:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com>
In-Reply-To: <4A031471.7000406@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> I completed the resurrection of the test and wrote up a little wiki on
> the subject, which you can find here:
>
> http://developer.novell.com/wiki/index.php/WhyHypercalls
>
> Hopefully this answers Chris' "show me the numbers" and Anthony's "Why
> reinvent the wheel?" questions.
>
> I will include this information when I publish the updated v2 series
> with the s/hypercall/dynhc changes.
>
> Let me know if you have any questions.
>   

Well, 420 ns is not to be sneezed at.

What do you think of my mmio hypercall?  That will speed up all mmio to 
be as fast as a hypercall, and then we can use ordinary mmio/pio writes 
to trigger things.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

