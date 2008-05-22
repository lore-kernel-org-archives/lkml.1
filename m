Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbYEVLwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbYEVLwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYEVLw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:52:27 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:37527 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYEVLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:52:26 -0400
Message-Id: <20080522114048.265996107@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 13:40:48 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/4] configfs: Make nested default groups lockdep-friendly v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patchset is another try to make configfs recursive inode locking
lockdep-friendly. This time lockdep_off()/lockdep_on() are not inserted, but
I_MUTEX_* lockdep sub-classes are tweaked to allow some variable-length
recursion on the spirit of I_MUTEX_PARENT -> I_MUTEX_CHILD -> I_MUTEX_CHILD + 1
-> ... The lockdep annotations added in configfs are a variant of a previously
submitted patch (see
http://oss.oracle.com/pipermail/ocfs2-devel/2008-May/002214.html ), with a much
lighter footprint, thanks to a suggestion from Joel.

Thanks for reviewing.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

