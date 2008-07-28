Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYG1Ku3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYG1Ku3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYG1KuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:50:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:17273 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYG1KuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ur0caP5FcBSFFoU5Qw76Q+WtVvZ2Hak4bOAn+EiCKPVm6fbtZGEuadF1emvsLT5Zd7
         phkzfRj/Xt8H/l0lCVCvB8GWdFQaEtm94vfMuACidMx24jsxe54pf669qaNbKbl0tOjD
         heFMFNcoQVYHFQEUBLed5FZD5GLRMBZ6uHVo8=
Message-ID: <f19298770807280350r79b2811er79061bb4fa363369@mail.gmail.com>
Date: Mon, 28 Jul 2008 14:50:19 +0400
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: commit a352def21a642133758b868c71bee12ab34ad5c5 broke pptp.
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <f19298770807231111p2aaa2a3eyc4bf0c084c626c9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770807231111p2aaa2a3eyc4bf0c084c626c9b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:11 PM, Alexey Zaytsev
<alexey.zaytsev@gmail.com> wrote:
> Hello.
>
>
> Pptp breaks for me on the current git (c010b2f76):
>
> root@nx:~# pppd call semunlim defaultroute nodetach debug
> Couldn't set tty to PPP discipline: Invalid argument
> Waiting for 1 child processes...
>  script pptp 172.18.2.2 --nolaunchpppd, pid 4359
> root@nx:~#
>
> It bisects to:
> a352def21a642133758b868c71bee12ab34ad5c5 tty: Ldisc revamp
>
> Revetring this commit, along with
> 7a4d29f426f17479395980ded8fa5e3bdd6d94e4
> and 01e1abb2c27e43339b8829a2e3b1c6f53806b77a fixes the problem.
>

Still there (c9272c4f). Could you maybe revert this for the -rc1? If not the
problem, this would probably be the first -rc1 ever that actually
works for me. ;)
