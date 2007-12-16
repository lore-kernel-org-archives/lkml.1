Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXLPLVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXLPLVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763161AbXLPLVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:21:37 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37849 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192AbXLPLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:21:36 -0500
Message-ID: <47650A4C.4000708@davidnewall.com>
Date: Sun, 16 Dec 2007 21:51:48 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
References: <20071216080441.435456586@I-love.SAKURA.ne.jp>	<20071216080628.061470932@I-love.SAKURA.ne.jp>	<200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
In-Reply-To: <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
>  /dev needs to be writable, but this means that files on /dev might be
>  tampered with.

I infer that you mean /dev needs to be writable by anyone, not by just 
its owner or owner and group (conventionally root/root.)  This goes 
against conventional wisdom, which is that /dev must be writable only by 
the administrator.  Why do you say otherwise?
