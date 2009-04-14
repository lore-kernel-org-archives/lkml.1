Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZDNQIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZDNQIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZDNQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:08:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZDNQIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:08:04 -0400
Message-ID: <49E4B4D4.1020903@zytor.com>
Date: Tue, 14 Apr 2009 09:07:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com> <49E45894.7090700@redhat.com>
In-Reply-To: <49E45894.7090700@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
> The comment about repeating 'mov ss' in the manual has that wonderful
> word in it, May.  That means we're perfectly allowed to ignore it and
> just set the flag unconditionally.
> 

Realistically, though, this should only be done for a limited number of
sequential instructions.

> I doubt we'll ever see a repeated 'mov ss', once is more than enough.

True enough, except maliciously.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

