Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZAFHTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZAFHTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZAFHS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:18:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:11848 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZAFHS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Qa3ZSm4ZKhJIe17wRjd+otuAukxcBM0oTRx4uGhEnw2Yzljyvv0HZwjoKVuG4dBJwu
         Siac7JaU26Auq4iVbT/BMuGG9ZN92RgkRvtrD2djH4TpB39TkF1omKbVP/C347i0nWdE
         WlYslUZooKC7cAO8LOuCoh7t4VicmPSSQRjc0=
Message-ID: <3f9a31f40901052318s7a5a421apa5c6ed8804aeb955@mail.gmail.com>
Date: Tue, 6 Jan 2009 12:48:56 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Cc: "Alain Knaff" <alain@knaff.lu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4962858F.20207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
	 <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu>
	 <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu>
	 <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu>
	 <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu>
	 <4962858F.20207@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 3:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I'm thinking that with "preferred" we might just use the first one in the
> priority list "lzma, bzip2, gzip, uncompressed" depending on what is
> installed in the kernel.
>

Only problem I faced with lzma is that, in some machines /usr/bin/lzma
is not installed by default which leads to error in kernel
compilations.

Can we check in kernel config that lzma is installed on machine or not.

--
JSR
