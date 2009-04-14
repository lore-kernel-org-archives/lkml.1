Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZDNQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZDNQZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZDNQZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:25:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZDNQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:25:32 -0400
Message-ID: <49E4B8E9.7050703@zytor.com>
Date: Tue, 14 Apr 2009 09:25:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com> <49E45894.7090700@redhat.com> <49E4B4D4.1020903@zytor.com> <49E4B654.6060101@redhat.com>
In-Reply-To: <49E4B654.6060101@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
> Why do we care?  The guest can only harm itself, and if it wants to
> disable interrupts, it would be a lot easier for it to run a plain 'cli'.
> 
> I guess it would be a problem if we emulated 'mov ss' for ordinary
> userspace or vm86 mode, but we don't.
> 

Well, the answer is that mov ss is an unprivileged instruction.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

