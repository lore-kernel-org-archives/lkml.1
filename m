Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYEAPyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYEAPyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbYEAPyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:54:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:4416 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbYEAPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=b6S+m1ppmSCmgyoVKVDh8kCrrXcUl0YXCcLJvBc+YfH3VD5UUWNsXkYiyGzsG4ZGK2crVNl33mMWKxaBQm1FXu5Zf0ReX0T4R9J31w18Lg0x4vViFNFAI0WPn0Q8beopxHIvX88Z19uvZnAYw5c6AV8ixbKvj4K4tmJY3hW4+2A=
User-Agent: quilt/0.46-1
Date: Thu, 01 May 2008 19:48:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 0/2] CIFS - small cleanup/fix
Message-ID: <4819e79f.0b38560a.23df.1917@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

here are two patches with intention to clean too indented
code. Also small fix in memcmp usage. And there is still
possible NULL pointer deref in CIFSNTLMSSPNegotiateSessSetup
if kzalloc fails - but I'm not sure how to properly hanlde that.

Any comments are welcome (the patches are over today Linus's git)

		- Cyrill -

-- 
