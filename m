Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYJaTqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYJaTqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJaTqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:46:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:57652 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYJaTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oKveKMIT6uNCmNrJJCl7NmMHFLDydxn2ob1q7cr6u0f18Z/JYvmP2hMeKOP3EhELn4
         tGF3Ih+S5dZ2QJxyImyGBfymxevcsTVJKdgX0DisFPYXSa/Uwee50o5pivH5rKy8645x
         fHZo9sjprBDcgM9mwa1SAUnaziEOtdo4r4ir8=
Message-ID: <490B606F.3010100@gmail.com>
Date: Fri, 31 Oct 2008 20:45:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jeroen Roovers <jer@gentoo.org>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: 2.6.28-rc2: USB/INPUT: slab error in cache_alloc_debugcheck_after():
 double free?
References: <200810310011.08618.deller@gmx.de> <20081031044553.50882e86@epia.jer-c2.orkz.net>
In-Reply-To: <20081031044553.50882e86@epia.jer-c2.orkz.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2008 04:45 AM, Jeroen Roovers wrote:
> I am seeing the same USB problem but without the SLAB errors - [1] is
> the Gentoo bug report. The kernel boots fine with both USB keyboard and
> mouse detached.
> 
> 
> [17179609.760000] usb 1-2: configuration #1 chosen from 1 choice
> [17179609.860000] input: Kensington Kensington USB/PS2 Trackball as
> /class/inpu1
> [17179609.972000] Backtrace:

Could you boot with slub_debug kernel parameter?
