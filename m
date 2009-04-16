Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZDPWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZDPWlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZDPWlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:41:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZDPWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:40:59 -0400
Message-ID: <49E7B3EB.6060101@zytor.com>
Date: Thu, 16 Apr 2009 15:40:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com> <49E45894.7090700@redhat.com> <49E4B4D4.1020903@zytor.com> <49E4B654.6060101@redhat.com> <49E4B8E9.7050703@zytor.com> <49E6F7D6.8010107@redhat.com>
In-Reply-To: <49E6F7D6.8010107@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
> We don't emulate guest user mode.
> 
> Well, if guest userspace can convince its kernel to give it access to 
> some memory mapped I/O register, I guess it can execute repeated 'mov 
> ss, mmio' and starve the guest kernel.
> 

It doesn't need a MMIO register to do that, even.

	-hpa
