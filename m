Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYC1S5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYC1S5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYC1S53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:57:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51929 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbYC1S53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:57:29 -0400
Date: Fri, 28 Mar 2008 19:57:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH one line: "vmlinux*.lds*" is in Documentation/dontdiff
Message-ID: <20080328185753.GA13229@uranus.ravnborg.org>
References: <219221.75156.qm@web28604.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <219221.75156.qm@web28604.mail.ukl.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 05:20:07PM +0100, Etienne Lorrain wrote:
>  Hi,
> 
>  Please can you remove vmlinux*.lds* of Documentation/dontdiff from linux-2.6.24-rc7,
> because a command like:
> diff -urN -X linux-2.6.24/Documentation/dontdiff linux-2.6.24 linux-2.6.24-gujin
>  does not include modifications of file "arch/x86/kernel/vmlinux_32.lds.S".
> 
>  Note also that the two files vmlinux_32.lds.S and vmlinux_64.lds.S have few lines
> which begin by "space space tab", but I do not want to start a flamewar in between
> vi, emacs and this other text editor...
Both these files are in a need for a consistency cleanup.
Have done so a few times but then lost the patch again.

Other like for example sparc64 have had such a cleanup.

	Sam
