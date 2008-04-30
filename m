Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbYD3Jmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbYD3Jmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYD3Jme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:42:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:38224 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYD3Jmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ltY+Rp7Fx1FB0ucv37PJpMk9xy4uyLWgfOVy+ACZS7p/BxP4E/3hnQm+5a9sjm0bcLbO47no4Egkxk0PzDrJ65F+a8MkgkNP6AUGMsZyZC4/Pjbqy7HgNeHCgneXFH2QSjIAqP1VZZgXfSYy1ueSud3tHFWT1s8RVPhO9lgKLwM=
Message-ID: <ed10ee420804300242k67350a3s50a1d4fb8813af75@mail.gmail.com>
Date: Wed, 30 Apr 2008 02:42:33 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: Why use /bin/sh in kernel build system?
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, "Mark Rustad" <mrustad@gmail.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Timur Tabi" <timur@freescale.com>,
       "Roland Kuhn" <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080429222456.GM8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481529B6.6030802@freescale.com>
	 <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de>
	 <48173607.6080307@freescale.com>
	 <20080429164501.GA18018@uranus.ravnborg.org>
	 <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com>
	 <20080429214107.GA22735@martell.zuzino.mipt.ru>
	 <20080429222456.GM8474@1wt.eu>
X-Google-Sender-Auth: 6be219bb6a99a5ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/08, Willy Tarreau <w@1wt.eu> wrote:
>  > On Tue, Apr 29, 2008 at 03:27:02PM -0500, Mark Rustad wrote:

>  > > Life is too short to keep having to fight silliness like this and I
>  > > can't see a valid reason why a system building a Linux kernel, or for that
>  > > matter gcc, should not have the bash shell installed on it.

> Hint: not every joe user may install bash into /bin... That's why we
>  see some scripts begin with "/usr/bin/env bash" as there are less
>  systems without env in /usr/bin than systems without bash in /bin (or
>  at all).

/bin/sh standard behaviour is defined.  We follow standards not written or
dictated by us.  I'm proud of that.

-sb
