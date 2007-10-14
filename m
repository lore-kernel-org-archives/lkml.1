Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbXJNMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbXJNMLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXJNMLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 08:11:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:31524 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbXJNMLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 08:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k4ujNN4ceLiA+NedU3sA4FwLpW0ookVpnSlAWffId6gGvqhSMVpCzYBi9whtr1gEJtzg2vo2BzCn940x77yyUMlvEAGUDgHUQsE9MN8g9jJYMCCxgtqxmExInLy5hm6gvIBsuDmfTpKxsqzYCqwotC1ppe5ZmFpGkKCS6KZJw8o=
Message-ID: <21d7e9970710140511w4b61efahb060c0ca376307ae@mail.gmail.com>
Date: Sun, 14 Oct 2007 22:11:06 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>
Subject: Re: 2.6.23(.1) Regression? i915 oopses and panics
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fet0ir$38b$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fesqkn$lml$1@ger.gmane.org>
	 <21d7e9970710140341i25afc47cwdd9e441a0d2e2d0f@mail.gmail.com>
	 <fesrv9$o97$1@ger.gmane.org>
	 <21d7e9970710140438p3e1c176et6c33ed4d7738364e@mail.gmail.com>
	 <fet0ir$38b$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Thomas Bächler <thomas@archlinux.org> wrote:
> Dave Airlie schrieb:
> >> I'm sorry, I forgot to mention that: As I _thought_ it had worked with
> >> rc6, I already found that commit. I reverted it and got a panic again
> >> (no trace, as I was in X), so this one doesn't seem to cause the problem.
> >>
> >
> > Okay I've spotted a potential bug that might lay hidden, try the
> > attached patch to see if it helps..
>
> I applied the patch, compiled i915.ko, rmmoded the old module, insmoded
> the new one and started X. The issue seems to be gone, googleearth
> starts again without any messages to syslog, so no oops and no panic.
>
> Will you submit this patch to the stable team?

As soon as I get it upstream into Linus's tree I'll forward it on to
the stable guys....

Dave.
