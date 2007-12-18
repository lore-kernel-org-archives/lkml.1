Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbXLRAQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbXLRAQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbXLRAPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:15:53 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63529 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760157AbXLRAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:15:52 -0500
Message-Id: <200712180003.lBI03N7F092396@www262.sakura.ne.jp>
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: "\"\\\"Serge E. Hallyn\\\"\"" <serue@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Dec 2007 09:03:23 +0900
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp> <20071217194802.GA14156@sergelap.austin.ibm.com>
In-Reply-To: <20071217194802.GA14156@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> CAP_MKNOD will be removed from its capability
I think it is not enough because the root can rename/unlink device files
(mv /dev/sda1 /dev/tmp; mv /dev/sda2 /dev/sda1; mv /dev/tmp /dev/sda2).

> To use your approach, i guess we would have to use selinux (or tomoyo)
> to enforce that devices may only be created under /dev?
Everyone can use this filesystem alone.
But use with MAC (or whatever access control mechanisms that prevent
attackers from unmounting/overlaying this filesystem) is recomennded.
