Return-Path: <linux-kernel-owner+w=401wt.eu-S1766007AbYB0DKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766007AbYB0DKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYB0DKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:10:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:61493 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYB0DKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KWi86dmAnVP20zBr224JrV7sJL2dmc/QtS7HwQku21phcVRanl5yhhpCtwhwUqN0+JGjQC6OF/CfYDm/WnmUUsXcd8I6yzARUOS+xhKvtx9wW/zUQmKhlPV1mBDeetjFVt4/kLLGNaeBl6RKQ9VmlVZCZtlRTJjwEyayyzrAjIQ=
Message-ID: <8499950a0802261910t55b3f80r1139c9c13ab9b198@mail.gmail.com>
Date: Wed, 27 Feb 2008 04:10:04 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: why filename extensions? (Re: [PATCH] Compress kernel modules on installation.)
Cc: "Willy Tarreau" <w@1wt.eu>,
       "Steve Brokenshire" <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 1:30 PM, Adrian Bunk <bunk@kernel.org> wrote:

>  depmod/modinfo/insmod/modprobe know only if you compile
>  module-init-tools with zlib support.
>
>  And what about the busybox versions?
>
>  A different name would e.g.:
>  - easily allow proper error handling if the userspace modules program
>   doesn't support the compression used
>  - better scale to support additional compressions
>  - give the user a hint what is happening and what might be the problem
>   when anythig goes wrong

Right...

http://article.gmane.org/gmane.linux.debian.devel.dpkg.general/8495
_______
