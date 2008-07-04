Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYGDChR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYGDChR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYGDChF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:37:05 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46641 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYGDChD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:37:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18541.35978.437115.957054@harpo.it.uu.se>
Date: Fri, 4 Jul 2008 04:35:54 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
In-Reply-To: <20080703234140.GC9594@localdomain>
References: <20080703234140.GC9594@localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch writes:
 > Some IBM POWER-based platforms have the ability to run in a
 > mode which mostly appears to the OS as a different processor from the
 > actual hardware.  For example, a Power6 system may appear to be a
 > Power5+, which makes the AT_PLATFORM value "power5+".
 > 
 > However, some applications (virtual machines, optimized libraries) can
 > benefit from knowledge of the underlying CPU model.  A new aux vector
 > entry, AT_BASE_PLATFORM, will denote the actual hardware.  For
 > example, on a Power6 system in Power5+ compatibility mode, AT_PLATFORM
 > will be "power5+" and AT_BASE_PLATFORM will be "power6".

Why on earth would you ever want AT_PLATFORM to differ from AT_BASE_PLATFORM?
In cases that matter you admit that AT_BASE_PLATFORM takes precedence,
so why involve a fake lame not-quite-the-platform in the first place?

Workaround for buggy software?
