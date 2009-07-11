Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZGKFLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZGKFLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 01:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZGKFLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 01:11:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:55004 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZGKFLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 01:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yIGLkelUH98E7QMYdanN+/UwFmJe/sMNgYDjXEVjRB08kadrAP06AnSwkqXjgifoLO
         CW/W8PqeJRmspwaeccxj++zNSlt2Bmwyn2v0X0nWs2r3eur+dYAc7vPwBVmgTfMgMl60
         wG59nFwH3pfBXeaf62fwYaaQHLKYLRe+Wtzbo=
Message-ID: <4A581F49.9090601@gmail.com>
Date: Fri, 10 Jul 2009 23:12:41 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wayne Pollock <pollock@acm.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: make xconfig fails on Fedora 10 for 2.6.30
References: <4A57BD9B.4030405@acm.org>
In-Reply-To: <4A57BD9B.4030405@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2009 04:15 PM, Wayne Pollock wrote:
> The "make xconfig" command tried to link to "libXi.so".
> I think this is actually a kernel bug; the binary this
> make command builds should try to link to some "soname"
> such as "libXi.so.6" instead, shouldn't it?

No, applications are generally supposed to link to the plain name, and 
the resulting binary will end up linked to the version-specific name 
because of the symlink. Applications don't generally need to know what 
version of the library they're linking against, if they care they can 
usually figure it out from the headers they are including.

>
> The work-around was to manually create the missing symlink
> for "libXi.so".  I suspect other distro's install that
> symlink automatically so maybe that's why the bug was
> not discovered.  But I believe it is correct to say all
> applications should use a soname (including the major
> version number), and not just the "linker" name (the
> name ending in ".so" with no version numbers).
>
> Or am I missing something?

Not a bug, the symlink is supposed to be there. (Could be you need to 
install some devel package to get it..)
