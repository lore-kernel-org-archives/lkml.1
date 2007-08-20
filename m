Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbXHTDPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbXHTDPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXHTDPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:15:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:17478 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbXHTDPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PYkSnqs2JeOowJYfNvUHKFa6fqrZ+ZGuehTcW1NowUPxBgsaTrD6TECaL4JwrdSzb6PeHSXNIoX0SoroBcgBfbCSXDxkZd+SGUu2O+wVm85JxicI8wKO5zNvAjigD8YQmYTn7VBL15IU0jjanWn8oMAnlgemScgeaK1wQTevkOY=
Message-ID: <2c0942db0708192015u2759ccfby320549cd6393dff3@mail.gmail.com>
Date: Sun, 19 Aug 2007 20:15:01 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 0/4] process memory footprint info in proc/<pid>/[s|p]maps v2
Cc: "Andrew Morton" <akpm@osdl.org>, "Matt Mackall" <mpm@selenic.com>,
       "John Berthels" <jjberthels@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <387510147.18695@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <387510147.18695@ustc.edu.cn>
X-Google-Sender-Auth: ad4aee1c88841517
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> Inspired by Matt Mackall's pagemap patches and ideas, I worked up these
> textual interfaces that achieve the same goals. The patches run OK
> under different sized reads.
[...]
> 2b7d6e8f3000-2b7d6ea40000 r-xp 00000000 08:01 1564031                    /lib/libc-2.6.so
> 0       2       YRAU___ 81
> 2       1       YRAU___ 80
> 3       1       YRAU___ 81
> 4       1       YRAU___ 72
> 5       1       YRAU___ 77
> 6       1       YRAU___ 79
> 7       1       YRAU___ 73
> 8       1       YRAU___ 79
> 9       1       YRAU___ 78
> a       1       YRAU___ 77
> b       1       YRAU___ 72
> c       1       YRAU___ 75
> d       1       YRAU___ 81
> e       1       YRAU___ 72
> f       1       YRAU___ 78
> 10      1       YRAU___ 81
> 11      1       YRAU___ 78
> 12      1       YRAU___ 80
> 13      1       YRAU___ 78
> 14      2       YRAU___ 81
> 16      1       YRAU___ 49
> 17      6       YRAU___ 41
> 1d      1       YRAU___ 80
> 2a      1       YRAU___ 44
> 2b      1       YRAU___ 69
> 2c      1       YRAU___ 28
> 31      1       YRAU___ 79
> 32      1       YRAU___ 49
> 33      1       YRAU___ 73
> 34      1       YRAU___ 57
> 35      1       YRAU___ 67
> 42      1       YRAU___ 77
> 43      3       YRAU___ 78
> 46      1       YRAU___ 77
> 47      1       YRAU___ 70
> 48      1       YRAU___ 15
> 4d      1       YRAU___ 78
> 5f      1       YRAU___ 78
> 60      1       YRAU___ 75
> 61      1       YRAU___ 72
> 62      1       YRAU___ 67
> 63      1       YRAU___ 59
> 68      1       YRAU___ 63
> 69      1       YRAU___ 61
> 6a      1       YRAU___ 63
> 6b      1       YRAU___ 75
> 6c      1       YRAU___ 76
> 6d      1       YRAU___ 81
> 6e      1       YRAU___ 77
> 6f      1       YRAU___ 79
> 70      1       YRAU___ 44
> 71      1       YRAU___ 79
> 72      1       YRAU___ 78
> 73      1       YRAU___ 79
> 74      1       YRAU___ 46
> 75      1       YRAU___ 78
> 76      1       YRAU___ 60
> 78      1       YRAU___ 79
> 79      1       YRAU___ 81
> 7a      1       YRAU___ 80
> 7e      1       YRAU___ 41
> 8a      1       YRAU___ 36
> 8b      1       YRAU___ 72
> 8c      1       YRAU___ 28
> 8d      1       YRAU___ 21
> 91      2       YRAU___ 19
> 99      1       YRAU___ 62
> 9a      1       YRAU___ 76
> 9b      1       YRAU___ 72
> c4      1       YRAU___ 80
> c5      1       YRAU___ 82
> c6      1       YRAU___ 81
> cb      1       YRAU___ 42
> cc      1       YRAU___ 79
> cd      1       YRAU___ 26
> cf      1       YRAU___ 12
> d0      1       YRAU___ 77
> d1      1       YRAU___ 38
> d2      1       YRAU___ 45
> d3      1       YRAU___ 66
> d4      1       YRAU___ 71
> e0      1       YRAU___ 52
> 106     1       YRAU___ 33
> 107     1       YRAU___ 14
> 108     1       YRAU___ 63
> 109     1       YRAU___ 57
> 10b     1       YRAU___ 70
> 10c     1       YRAU___ 63
> 118     1       YRAU___ 65
> 119     1       YRAU___ 78
> 11a     1       YRAU___ 69
> 11b     1       YRAU___ 68
> 11e     2       YRAU___ 62
> 120     1       YRAU___ 74
> 121     1       YRAU___ 42
> 125     1       YRAU___ 17

Eh, I'd think that pivoting the data set would be a much more natural
(& therefore shorter) representation.

YRAU___ 0,2:81 2:80 3:81 4:72 5:77 6:79 7:73 8:79 9:78
...versus...
> 0       2       YRAU___ 81
> 2       1       YRAU___ 80
> 3       1       YRAU___ 81
> 4       1       YRAU___ 72
> 5       1       YRAU___ 77
> 6       1       YRAU___ 79
> 7       1       YRAU___ 73
> 8       1       YRAU___ 79
> 9       1       YRAU___ 78

So, flags followed by a list of offset[,length]:usage. If the flags
change, start a new line. If you get a line that's too long, start a
new line.

No?
