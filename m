Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZCJOR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZCJOR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZCJORU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:17:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:28976 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZCJORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=gR2bruxI98iLIZaLDfy84MCP4isIw5sEFbriValI/KR1ZzLipl78TWaL3OLOsL2+TF
         MpnUSdMB/Gehp6EVEI6gNwmJKO1UFl9zKmha2YjPQN1XNYq/H4IbB68UB1SZ7qkuvE3v
         f1nQ4gZgK4wPNeEgAzC8lmCf86yfHL47NGeEE=
MIME-Version: 1.0
In-Reply-To: <a63d67fe0903100539r6ca3d789m4be81239eba2bf3b@mail.gmail.com>
References: <a63d67fe0903100539r6ca3d789m4be81239eba2bf3b@mail.gmail.com>
Date: Tue, 10 Mar 2009 17:17:16 +0300
Message-ID: <a63d67fe0903100717o81cb5efx80faf5d787a9a9e9@mail.gmail.com>
Subject: Re: smatch 1.51 released
From: Dan Carpenter <error27@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       smatch-discuss <smatch-discuss@lists.sf.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/09, Dan Carpenter <error27@gmail.com> wrote:
> Smatch follows the kernel naming scheme so odd numbers are devel
> releases.  The .51 means over half finished.
>
> Smatch is available from:  http://repo.or.cz/w/smatch.git/
>

Sorry, a couple people complained that I didn't actually say what smatch was.

It's an static analysis type error checker.  It finds different bugs
than sparse.  It's more like the stanford checker or maybe Microsoft's
PREfix.  It can find more complicated bugs than coccinelle but it
can't fix them automatically.  One key selling point is how simple it
is to write checks.

The error messages look like this:
drivers/scsi/pcmcia/nsp_cs.c +1725 nsp_cs_config(19) info: ignoring
unreachable code.

The 1725 is the line number.  nsp_cs_config(19) is the function and
line number within the function.

Most of the error messages are false positives honestly, but some are real.

regards,
dan carpenter
