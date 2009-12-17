Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbZLQRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbZLQRuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbZLQRuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:50:12 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:57310 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZLQRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sIU0SqP4miTkQNGSx/LHVpj4OjuGFNliPHTRkZvPf1GPr/kMlHaekqjI9MrJ3P7Eb1
         LYQZNrUUwHQBAL8OGe1sJW/BcTQXm9ZOyXLLWlZl/GB7GNmReYBah24J7B4zMBpdpAsa
         643wJNtBAMVrbzkv/bPZ+iRANCqz6lHYlS9bk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912170940470.5991@axis700.grange>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
	 <Pine.LNX.4.64.0912101833170.4487@axis700.grange>
	 <20091211080254.GB7625@linux-sh.org>
	 <29ab51dc0912111815s2095539cjc3d0450435725452@mail.gmail.com>
	 <29ab51dc0912161909r7a6e5397sc751a49a636d755d@mail.gmail.com>
	 <Pine.LNX.4.64.0912170831430.5991@axis700.grange>
	 <29ab51dc0912170033s4185153emc1aaafdc83607532@mail.gmail.com>
	 <Pine.LNX.4.64.0912170940470.5991@axis700.grange>
Date: Thu, 17 Dec 2009 10:50:07 -0700
X-Google-Sender-Auth: 12bcf19898ef5d99
Message-ID: <e9c3a7c20912170950g755f8774i768d3c9502a0f601@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] sh: fix DMA driver's descriptor chaining and 
	cookie assignment
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 1:43 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Sure, I never assumed the opposite, that's why I said "you forgot." Same
> thing happened to me too recently, fortunately, I noticed it early enough
> to push a correct version. The actual problem with your version was
> white-space changes.

I kept your original v2 patch.  You can double check the state of my
'fixes' branch [1].

Thanks,
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=refs/heads/fixes
