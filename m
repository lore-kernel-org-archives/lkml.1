Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbYJMKRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbYJMKRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765668AbYJMKNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:13:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:24107 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762170AbYJMKNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=P/q1IPX0Xwh/IcjpXES9gsTUo1KQuOAinKI8tA7fHBIYuGQwWwhwTYZeMRs/SUX1Av
         40HnORp0GoozkJy33obxEBJ9DeG9d7MW9ICV0oWcivdAo8ywsMq0Mfs2corzRHyDh0KK
         a40XsIQl+7ugim7e5mI7/0B9VRTIy1O2cGPm8=
Message-ID: <48F31F44.9090507@gmail.com>
Date: Mon, 13 Oct 2008 12:13:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: GIT head no longer boots on x86-64
References: <20081013102330.46066092@lxorguk.ukuu.org.uk>
In-Reply-To: <20081013102330.46066092@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2008 11:23 AM, Alan Cox wrote:
> The boot ends on the first module load with a crash
> 
> 	BUG: mm/vmalloc.c 118

Not 187? 118 is currently a line with `{'. Which git SHA? Is DEBUG_VIRTUAL=y?

> From
> 	text_poke
> 	alternatives_smp_unlock
> 	alternatives_smp_module_add
> 	module_finalize
> 	load_module
> 
> while loading the EHCI driver
