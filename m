Return-Path: <linux-kernel-owner+w=401wt.eu-S934637AbZLPIEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbZLPIEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760233AbZLPIEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:04:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028AbZLPIEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:04:33 -0500
Date: Wed, 16 Dec 2009 08:04:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: devtmpfs [censored] oddities
Message-ID: <20091216080431.GF14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	May I respectfully suggest that a blocking operation (such as
kstrdup with GFP_KERNEL, or grabbing a mutex, or, say it, pathname resolution)
is not quite the thing to do while holding an rwlock?

	As it is, any device_add() is an embarrassingly obvious deadlock
waiting to happen...
