Return-Path: <linux-kernel-owner+w=401wt.eu-S964996AbXA3D4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964996AbXA3D4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965059AbXA3D4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:56:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964996AbXA3D4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:56:11 -0500
Date: Mon, 29 Jan 2007 22:55:46 -0500
From: Dave Jones <davej@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __u32 in asm-x86_64/msr.h
Message-ID: <20070130035546.GC21772@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mike Frysinger <vapier@gentoo.org>, ak@suse.de,
	linux-kernel@vger.kernel.org
References: <200701291925.08670.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701291925.08670.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 07:25:08PM -0500, Mike Frysinger wrote:
 > the checking_wrmsrl() macro in asm-x86_64/msr.h which is exported to userspace 
 > utilizes the u32 type instead of __u32 ... trivial attached patch fixes that

Better would be to not export those macros to userspace at all,
as they can't be used outside of ring 0 anyway.

		Dave

-- 
http://www.codemonkey.org.uk
