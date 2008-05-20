Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbYETMOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbYETMOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYETMOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:14:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:10591 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbYETMOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JCsn9G9PWOzD4/2QdIUmAKuFppTGgZeo3lVNlF+/QWxWGZ09gKf69mb2uxd5YdqWvqEbjm+CxolY/Tk5s5CiG73ap2j6TaI3ez4/gUjptKv6echud/7Ty1kX7M+PaIT0Vwc5U7vdJLuo/jw3wpU8KZRJ9NG1vzlnb7U+eGB73zU=
Message-ID: <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com>
Date: Tue, 20 May 2008 21:13:59 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Soumyadip Das Mahapatra" <kernelhacker@visualserver.org>
Subject: Re: [PATCH 1/2] bitreversal program
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805201254240.18899@visualserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>
	 <1211229736.5915.86.camel@brick>
	 <Pine.LNX.4.64.0805201254240.18899@visualserver.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> -static inline u8 bitrev8(u8 byte)
>
> It is a static function, so you cant use it from outside of this
> file. So there should not be anyone using this function.
>

bitrev8() is static inline function in header file.
There are several users:

./drivers/isdn/gigaset/asyncdata.c
./drivers/isdn/gigaset/isocdata.c
./drivers/isdn/hisax/st5481_b.c
./drivers/rtc/rtc-s35390a.c
...
