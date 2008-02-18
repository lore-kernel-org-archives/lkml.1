Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYBRQPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYBRQPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYBRQPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:15:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:50645 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYBRQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L9xemLYTULd6EUFpSOPEipq1RbcN+X96iPCZI/2I820zN4Kl2tBSt7GxNB7Y6hlJf98eG+u041fTVh95nptW+9Ovea4Ie06Zj33LaUsPsKvryW3wBeM2qvY4XE/OugedvpxLMOdYQ3zCD11F03ryp2H6CZ3HPdxk/Rzztmzk9A4=
Message-ID: <2c0942db0802180815r59c2ef1s8d4c2e1e733b79c4@mail.gmail.com>
Date: Mon, 18 Feb 2008 08:15:01 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Romano Giannetti" <romanol@upcomillas.es>
Subject: Re: 2.6.25-rc1/2 regression: first-time login into gnome fails
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1203332161.26696.11.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203332161.26696.11.camel@pern>
X-Google-Sender-Auth: b80801a39c423063
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 2:56 AM, Romano Giannetti <romanol@upcomillas.es> wrote:
>
> Hi,
>
>         I have a very strange, but fully reproducible, regression with
> 2.6.25-rc1 -rc2. I have an ubuntu 7.10 fully updated.
>
>         The first time after boot, when I login to gnome (through gdm)
> the login half-fails with a Setting Daemon error: failed to connect to
> socket /tmp/dbus-<some random stuff>: connection refused. Nothing in the
> logs, and there is no such socket in /tmp.
>
> If I log out and then log in again, all works ok.
>
> With 2.6.24.2 there is no such a problem.
>
> .config, dmesg (2M buffer size) and syslog here:
>
> http://www.dea.icai.upcomillas.es/romano/linux/info/
>
>
>         Romano
>
>
> (Back to 2.6.24.2, because ndiswrapper broke again, and ath5k doesn't
> like (yet) my atheros adapter...)

It may be a race. Please try booting up, then waiting for a minute or
two once you see the gdm login screen, then try logging in.

If that succeeds then something (dbus perhaps) is hanging on something
that eventually times out.

Ray
