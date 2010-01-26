Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171Ab0AZHoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0AZHoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189Ab0AZHoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:44:17 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33892 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0AZHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TtfBgHPnzIVCIOS23lfErewY+QX2AfhFk3dLh2+mCyaIWQgw5wmTNiQ7j0xaekZwfZ
         Wf1pd85neUaJYKSDBUv+GDZAH1dUDoPbCWHhRCC0if3/UvCWbuIYXpcJDt78qp7qiS/y
         au1gWDWeboAN58H9+XYC5wqzx8JwZmaLHYN/4=
MIME-Version: 1.0
In-Reply-To: <cf70f0211001222331y17af1f56oe7d4e61c1d38d7d3@mail.gmail.com>
References: <cf70f0211001222331y17af1f56oe7d4e61c1d38d7d3@mail.gmail.com>
Date: Tue, 26 Jan 2010 08:44:14 +0100
Message-ID: <63386a3d1001252344u3ff7bb12q97ee65da13b69a9@mail.gmail.com>
Subject: Re: measureing kernel & application boottime's
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Shivdas Gujare <shivdas.tech@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/23 Shivdas Gujare <shivdas.tech@gmail.com>:

> I am trying to measure kernel boottime along with measuring
> application process start time on ARM V6 platform.
> Because of few reasons, I have to stick to kernel 2.6.25(can't upgrade
> it to latest).
(...)
> Also, Is there any best method to measure application start time
> (except bootchart, can't use it)?

Upgrade anyway. Seriously. It's for your own good. The best way to get
a bootchart without bootchart is to backport bootchart to kernel 2.6.25
and then the best strategy to do that is likely to upgrade to kernel 2.6.32
and rename it 2.6.25 and say it's a backport of the entire 2.6.32 to 2.6.25 :-P

Yours,
Linus Walleij
