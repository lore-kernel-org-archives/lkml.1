Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbZLJVeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbZLJVeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761337AbZLJVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:34:04 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:59331 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbZLJVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=p0+1sH1VeOrIxCkZogi7PODoyZd1/PhonDMFNC19r7PMzP9iFWzq1ZDknDBKQibPA+
         oAPRceowdfO5VBQKPK8V/PKRHllSE+bi1CZLLd5Ui3/PpgrG4bE24jVTgmvTNmRvFnLC
         f1UsWUgetShiFVnTQHNGYHg9UPiJaGkDJsTzc=
MIME-Version: 1.0
In-Reply-To: <1260466101-17545-5-git-send-email-ddaney@caviumnetworks.com>
References: <4B212EEC.3060808@caviumnetworks.com> <1260466101-17545-5-git-send-email-ddaney@caviumnetworks.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 10 Dec 2009 16:33:49 -0500
Message-ID: <8bd0f97a0912101333x2ba210d8ib1936bffa0ef2d7b@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 5/5] blackfin: Convert BUG() to use 
	unreachable()
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 12:28, David Daney wrote:
> Use the new unreachable() macro instead of for(;;);

sorry, i guess i missed this back in Sept.  change looks fine to me
(i'll test it later when finishing putting together other patches).
you want me to push though my queue ?  doesnt matter to me.
-mike
