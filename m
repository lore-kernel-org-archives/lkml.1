Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXEAPqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXEAPqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXEAPqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:46:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbXEAPqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:46:02 -0400
Message-ID: <463760B0.8020705@redhat.com>
Date: Tue, 01 May 2007 11:45:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [24/30] x86_64: Shut up warnings for vfat compat ioctls
 on other file systems
References: <20070501557.815359000@suse.de> <20070501035822.B3FC613CAF@wotan.suse.de>
In-Reply-To: <20070501035822.B3FC613CAF@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> vfat implements compat handlers for these ioctls, but when they
> were executed on other file systems the kernel would still complain
> about an unknown compat ioctl.  Just declare them as compatible
> and let them be rejected when not needed by the normal path.
> 
> This makes wine runs a lot quieter

Does this also restore the original -ENOTTY return code?

The change that made it return -EINVAL broke a few Wine apps.

