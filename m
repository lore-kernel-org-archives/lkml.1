Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbZEFR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbZEFR7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZEFR7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:59:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42335 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbZEFR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:59:07 -0400
Date: Wed, 6 May 2009 18:59:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: ericvh@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: oddity in v9fs_kill_super()
Message-ID: <20090506175906.GW8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason to do v9fs_dentry_release(s->s_root) in ->kill_sb()?
It is called when root dentry is freed and it will be freed just fine...
