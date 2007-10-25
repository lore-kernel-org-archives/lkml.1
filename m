Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbXJYUMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbXJYUMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXJYUMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:12:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:28326 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXJYUMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ffbIH+PY3qMFufWrtpeULEGP3Gdi0OX5Ag9LPwmN4kXWRElLlWtsytQJ3m9jQc4EAp7HpnW041AZ/ZKFF/nuGtACjsD/Cdwh4N/FNx41vKO5M2NVTySvvEt4s4DBdDST2da3+EpkLkS5Q3eWXMfOpe98WHw8hxHmF5OCKwJvOlg=
Message-ID: <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
Date: Thu, 25 Oct 2007 21:12:45 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Possibility of adding -march=native to x86
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071025195020.GS30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
	 <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
	 <20071025185022.GP30533@stusta.de>
	 <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
	 <20071025191723.GQ30533@stusta.de>
	 <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>
	 <20071025195020.GS30533@stusta.de>
X-Google-Sender-Auth: 8aae1b6f027efe7b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The MPENTIUM4 option does not only set -march=pentium4, it also enables
> several other options in arch/i386/Kconfig.cpu resulting in better
> performance.

How about an autodetect to set the right options here too using cpuid?

With a warning of course that the code produced will be specifically
for the native cpu that it's compiled on.
