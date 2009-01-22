Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZAVAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZAVAr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZAVArt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:47:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZAVArs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:47:48 -0500
Message-ID: <4977C1D3.2010801@zytor.com>
Date: Wed, 21 Jan 2009 16:46:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
CC: Grant Grundler <grundler@parisc-linux.org>, arnd@arndb.de,
       davem@davemloft.net, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <20090121224335.099C94F30@hiauly1.hia.nrc.ca>
In-Reply-To: <20090121224335.099C94F30@hiauly1.hia.nrc.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John David Anglin wrote:
>>> CONFIG_64BIT on parisc user space looks very wrong.
>> This shouldn't be exported to user space. Is that what you meant?
> 
> This does get exported to user space as applications sometimes need
> to know whether they are running under a 32 or 64-bit kernel.  See
> config.guess.  However, it certainly would be wrong to use this
> to make decisions about user space.
> 

CONFIG_* macros are not (or at least should not) be exported to 
userspace!  Userspace should not make compile-time decisions based on 
kernel configuration -- a runtime property!

	-hpa

