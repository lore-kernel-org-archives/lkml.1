Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYCVVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYCVVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYCVVPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:15:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbYCVVPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:15:18 -0400
Message-ID: <47E576B9.6090205@zytor.com>
Date: Sat, 22 Mar 2008 14:14:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: gorcunov@gmail.com
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86 - relocate_kernel cleanup
References: <20080322210005.117475478@gmail.com>
In-Reply-To: <20080322210005.117475478@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gorcunov@gmail.com wrote:
> The main purpose of this patches is to eliminate numeric constant and
> use predefined macroses. Please review. I've tested 64bit version on
> object level - it remains the same. Any comments are welcome.

Looks good.  Since you're doing work in this realm, you may also want to 
replace the old TF_MASK etc macros with X86_EFLAGS_TF etc.

	-hpa
