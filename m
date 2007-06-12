Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbXFLVY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbXFLVY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbXFLVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:24:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbXFLVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:24:20 -0400
Date: Tue, 12 Jun 2007 17:24:03 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/2] UML - Remove PAGE_SIZE from libc code
Message-ID: <20070612212403.GD15041@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>,
	uml-devel <user-mode-linux-devel@lists.sourceforge.net>
References: <20070612164806.GA7517@c2.user-mode-linux.org> <20070612140544.40123d0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612140544.40123d0c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 02:05:44PM -0700, Andrew Morton wrote:
 > On Tue, 12 Jun 2007 12:48:06 -0400
 > Jeff Dike <jdike@addtoit.com> wrote:
 > 
 > > Distros seem to be removing PAGE_SIZE from asm/page.h
 > 
 > They do?  That seems like a strange thing to do.  I wonder why, and I
 > wonder why such a change isn't needed in the mainline tree.

>From userland includes, yes.  User apps should be using getpagesize()

	Dave

-- 
http://www.codemonkey.org.uk
