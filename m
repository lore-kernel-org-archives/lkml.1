Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbXJMHnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbXJMHnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXJMHne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:43:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:11813 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXJMHnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jhTvr9i73DHHOwqxNbeM1cEevxeIdz1447mNfHxB/j2aVsWFNBPG1qn+uqMB5EeYhVy808zD3+QjT7crjX7qqTd9fT5N4eIxBojhP0svuESRbMbqMtEXtXDkVPWRhb5JLd02r50zp24IKbPLx/ZpcaqPfCiT8ePquXOQO3KFdW4=
Message-ID: <84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com>
Date: Sat, 13 Oct 2007 10:43:32 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: How to find slab\'s usage?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>
X-Google-Sender-Auth: 2a21f4b3c651ab70
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/12/07, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> I saw /proc/meminfo and it seems to me that slab is leaking memory.
> But /usr/bin/slabtop claims /proc/slabinfo is missing.

Do you have CONFIG_SLUB enabled? Try looking into /sys/slab/.

                                      Pekka
