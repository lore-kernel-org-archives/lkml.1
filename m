Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXKGDlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXKGDlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXKGDl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:41:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:64369 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbXKGDl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:41:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WUqJaUGcVnRQZVkMjbmpoNa+2UIvVjHbHcRALInsiVvGBccI/HKgyEl1+XFVyZs/DJubQtzVIFPKiOWVoekpIBsVYAJk16bWZsp0MyKkfFHtxrF4lLDbUZ5H1rLph/GyDLrVsA4rzqPD28+TKJ5MJXwnw61ZjpPSpXw8H8+Sbb0=
Message-ID: <8bd0f97a0711061941x743eba2ar7c13cd52238d9a9d@mail.gmail.com>
Date: Tue, 6 Nov 2007 22:41:28 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: [2.6 patch] blackfin: remove dump_thread()
Cc: "Adrian Bunk" <bunk@kernel.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <386072610711061939j66e89f95s59e4e4ab4cbdbee9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071105170750.GW12045@stusta.de>
	 <386072610711061907q7809db9ct51d00fe2d6ec6c6b@mail.gmail.com>
	 <20071107032831.GW26163@stusta.de>
	 <386072610711061939j66e89f95s59e4e4ab4cbdbee9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 10:39 PM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> On Nov 7, 2007 11:28 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Wed, Nov 07, 2007 at 11:07:06AM +0800, Bryan Wu wrote:
> > > On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> > > > This patch removes the unused dump_thread().
> > >
> > > Why only remove it from Blackfin? any more reason?
> >
> > The only user is the a.out support.
> >
> > It was therefore removed prior to the blackfin merge from all
> > architectures not supporting a.out.
>
> OK, make sense. Currently, Blackfin doesn't suppport a.out.

and hopefully never will
-mike
