Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXCQNSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXCQNSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCQNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:18:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:45034 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826AbXCQNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iWlAq/fTCyvviDSnRuHt2JSvk4fPckQsFKyGXDZJ6grE1S44VuBfBf6lZLNlDAxEsOOaEYO2cuH9zykbdqIOBBtRtPjn/KFzkhdNsU5g+JpAqG6uYQ26witi0B74GWkxm9Iqdkuz4xBUR36qYOIuHDLtqb8/vBDKfYc6ZJLuIOw=
Message-ID: <84144f020703170618x73808b4fmf5b420f4c2e02818@mail.gmail.com>
Date: Sat, 17 Mar 2007 15:18:10 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Thomas Meyer" <thomas@m3y3r.de>
Subject: Re: Bug in pci_restore_msi_state
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45FBE22A.8030304@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FBE22A.8030304@m3y3r.de>
X-Google-Sender-Auth: edce721c17d1ce83
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/07, Thomas Meyer <thomas@m3y3r.de> wrote:
> Hello everybody.
>
> I get this bug after suspending to disk twice:
>
> http://m3y3r.de/bilder/Bug-pci_restore_msi_state.png
>
> This happens with current git head cd05a1f818073a623455a58e756c5b419fc98db9.

If you know a kernel that works, please consider doing git bisect:

http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
