Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbXFSUUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbXFSUUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761240AbXFSUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:19:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39085 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761019AbXFSUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:19:55 -0400
Date: Tue, 19 Jun 2007 22:19:57 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: exported fb_find_logo references __initdata
Message-ID: <20070619201957.GA21306@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


fb_find_logo() refences a few structs marked as __initdata. The structs
itself have a member ->data which is marked as __initdata as well.
scripts/pnmtologo.c write_footer() and write_header() create those
structs.

What is the correct fix, and why does it work at all?
