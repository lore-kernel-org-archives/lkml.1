Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZKBPjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZKBPjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZKBPjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:39:10 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34021 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbZKBPjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RnlENrvM40JNAbkeA6qM6LLbduTV373ZPUDuACxteIYlxSrdObyR+AHfgfsyTSnEew
         8J2sr/Wu1QLWRPZEyWi2SW2/HUX1+MCYojie4pFAYrEs27jWCD/zdqjtEbcp9X4Gu95J
         oW+5ZXUzGlnfBO1d+qe4LbL5YNeEs2amE81lk=
From: Diego Calleja <diegocg@gmail.com>
To: "Ryan C. Gordon" <icculus@icculus.org>
Subject: Re: FatELF patches...
Date: Mon, 2 Nov 2009 16:40:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc5-00336-g8d5eb43; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <20091102000147.424f104b@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911012023020.55434@caridad.local>
In-Reply-To: <alpine.OSX.1.10.0911012023020.55434@caridad.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911021640.14114.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lunes 02 Noviembre 2009 03:21:47 Ryan C. Gordon escribió:
> FatELF solves different problems than package managers, and in the case of 
> ia32 compatibility packages, it helps the package manager solve its 
> problems better.

Package managers can be modified to allow embeddeding a package inside of
another package. That could allow shipping support for multiple architectures
in a single package, and it could even do things that fatelf can't, like
in the case of experimental packages that need other experimental
dependencies: all of them could be packed in a single package, even with
support for multiple architectures. Heck, it could even be a new kind of
container that would allow packing .rpm and .debs for multiple distros
together. And it wouldnt touch a single line of kernel code.

So I don't think that fatelf is solving the problems of package managers,
it's quite the opposite.
