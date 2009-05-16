Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZEPC2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZEPC2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 22:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZEPC2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 22:28:09 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:56348 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZEPC2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 22:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qtt3BF6KgntV26DVGWmIVypg0VTxTOsW1NInAqd1OJ4oPhL0HN8WV8gtuGAiVwJ2dh
         Enj1iJESSiHJjExeixDZz40xJbVi3ceQ9tL+OQdPG0Wuk43rfpgdvZjCtn5ynTuGTzCe
         xIjWcilrASMFdGE1YE8/z847ot6U4zi9BMyvA=
MIME-Version: 1.0
In-Reply-To: <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
Date: Sat, 16 May 2009 07:58:09 +0530
Message-ID: <93655eb70905151928l1dfdf9e0k138485c3080010ea@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which kernel version? If it's something recent, your programs may be
> getting swapped out due to a flaw in the latest kernels, where it
> accidentally prefers caching file data over mapped pages. If that's
> the case, Rik (cc:d) is working on patches to address the issue, and
> may appreciate another tester.
this may be the reason, I have seen this lag only with kernel >
2.6.28, currently I am running vanilla kernel 2.6.29.1 .


Satish
-- 
http://satish.playdrupal.com
