Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZDKQ5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZDKQ5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbZDKQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:57:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbZDKQ5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:57:30 -0400
Message-ID: <49E0CBB0.9030105@redhat.com>
Date: Sat, 11 Apr 2009 19:56:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org, bhutchings@solarflare.com,
       andi@firstfloor.org, gregkh@suse.de, herber@gondor.apana.org.au,
       chrisw@sous-sol.org, shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 14/19] kvm: add a reset capability
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163155.32740.50340.stgit@dev.haskins.net>
In-Reply-To: <20090409163155.32740.50340.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> We need a way to detect if a VM is reset later in the series, so lets
> add a capability for userspace to signal a VM reset down to the kernel.
>   

As I mentioned, this won't be reliable.  It needs to be driven from 
userspace and be per-device.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

