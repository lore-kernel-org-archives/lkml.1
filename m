Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbZKIGav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbZKIGav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 01:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZKIGau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 01:30:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZKIGau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 01:30:50 -0500
Message-ID: <4AF7B715.7080205@zytor.com>
Date: Sun, 08 Nov 2009 22:30:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
References: <1257512389.4af41dc504e1b@imp.free.fr> <20091106131330.0ce956f4@lxorguk.ukuu.org.uk> <4AF488A7.4010408@free.fr>
In-Reply-To: <4AF488A7.4010408@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 12:35 PM, matthieu castet wrote:
> 
> May be the sane way should be to forbid mapping page 0, and make run
> application needing page 0 in a
> emulator. After all it is for special case [1] :
> - Win16 binary for wine
> - upstream version of dosemu and qemu have workaround
> 
> But some distro still set mmap_min_addr to 0 (ubuntu+wine, ...) :(
> 

Don't Do That, Then[TM].

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

