Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZJ1WsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZJ1WsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZJ1WsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:48:05 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:50108 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZJ1WsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:48:04 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Milan Dadok <milan@dadok.name>, "'Greg Kroah-Hartman'" <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH] 1/4 staging: hv: fix oops in vmbus - udev events
Thread-Topic: [PATCH] 1/4 staging: hv: fix oops in vmbus - udev events
Thread-Index: AcpYHUUGwI6sw3PnR4SEuC//R6HTwgAAwktg
Date: Wed, 28 Oct 2009 22:48:06 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E7EE9FF@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <001401ca581d$456c45e0$d044d1a0$@name>
In-Reply-To: <001401ca581d$456c45e0$d044d1a0$@name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Milan,

First of all thanks for these patches!

Greg, I do have a request though. But I am not sure what the right approach is. This
Patch removes more than I would like. It takes out a few things that I would like to 
Keep in because I need them for prior versions of the kernel that we also have this
Running on.

What is the suggested approach in this case. Can I submit a patch instead of this one
That keeps some of these items still in?

Thanks,

Hank.


-----Original Message-----
From: Milan Dadok [mailto:milan@dadok.name] 
Sent: Wednesday, October 28, 2009 3:23 PM
To: 'Greg Kroah-Hartman'
Cc: linux-kernel@vger.kernel.org; Hank Janssen; Haiyang Zhang
Subject: [PATCH] 1/4 staging: hv: fix oops in vmbus - udev events

Fix typos in udev event send and guid variables copy

Signed-off-by: Milan Dadok <milan@dadok.name>

---

SNIPPAGE!

-       int i = 0;
-       int len = 0;
        int ret;

-       env->envp_idx = i;
-       env->buflen = len;

SNIP AND MORE SNIP

-       env->envp[env->envp_idx] = NULL;
-
        DPRINT_EXIT(VMBUS_DRV);



