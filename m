Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbZHDWxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbZHDWxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933358AbZHDWxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:53:23 -0400
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:34817 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933336AbZHDWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:53:22 -0400
X-Greylist: delayed 2809 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 18:53:22 EDT
From: Justin Banks <justinb@bakbone.com>
Date: Tue, 4 Aug 2009 16:06:32 -0600
To: linux-kernel@vger.kernel.org
Subject: security module question
Message-ID: <20090804220632.GG26133@bleen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello - I'm trying to implement a security module that will allow or
disallow writes on files by byte ranges. Is there a way to use
inode_permission() to do this, or is there an alternative route I should
take? It doesn't look like inode_permission() will give me the data I
need (offset + length of write).

Also, is there a security module that will examine data being written
for certain patterns or content?

Please CC: me on responses. I used to be subscribed, but the traffic was
just too much.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
