Return-Path: <linux-kernel-owner+w=401wt.eu-S936187AbYBVAaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936187AbYBVAaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936020AbYBVA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:29:51 -0500
Received: from namei.org ([69.55.235.186]:43624 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935862AbYBVA3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:29:48 -0500
Date: Fri, 22 Feb 2008 11:29:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Boot hang with stack protector on x86_64
Message-ID: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been getting an immediate hang on boot since:

e06b8b98da071f7dd78fb7822991694288047df0 kbuild: allow -fstack-protector to take effect

This is on an x86_64 system (actually an Intel SDV -- so it might be 
"special").

My .config has the following:

CONFIG_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR_ALL=y

Let me know if you need more information.


Interestingly, git-bisect was unable to identify the changeset, and 
reliably mis-identified this as the problem:

71c044752cdae89136862495f244d37073e2cf66 V4L/DVB (7080): zr364xx: add support for Pentax Optio 50

(which I don't even build).


- James
-- 
James Morris
<jmorris@namei.org>
