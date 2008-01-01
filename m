Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYAAHNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYAAHNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYAAHM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:12:59 -0500
Received: from po-out-1718.google.com ([72.14.252.155]:45571 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYAAHM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:12:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=JOE/H1N3XKLZT0QbM/XL9vufGDV2wBSw8Uk+FUU+UIBNvVJqYZvS7Sy+Q1tR+LI54HX06+80v2LdcAUhwi/9aXXpuJihDNMesl0jhn8KFdgT5P1IADFJw5BNev4AO9Gco8K2stziO/RnHEKUSElDwIS3fsuwY/seZmgx3PfjBG0=
Date: Tue, 1 Jan 2008 15:13:11 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch 0/8] Remove 'TOPDIR' from Makefiles
Message-ID: <20080101071311.GA2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, use srctree or objtree instead.

This patch set removes all the TOPDIR use in the whole
source tree and finally drops it in the top Makefile.
They're against the current linus-tree.

Note that Patch [8/8] should be applied _after_ all the
previous patches are applied.

Regards.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@osdl.org>


