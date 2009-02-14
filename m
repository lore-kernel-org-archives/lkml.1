Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZBNTPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZBNTPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 14:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZBNTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 14:15:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:16271 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZBNTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 14:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OqxyvCrIZP+V2qbwCB+Tpz9F9V1eOCxKvOW2gFtBBYGok18ql0vfkGkPt2AXaME3/f
         zrHFBjWjaQh06zD3QJyvK+lT9jj/v/+ZdwvkRWseBW9l3iPwGB8ga8k0Cpw0cf5oOJsR
         JDwMxWy1a2Qtc/n6SBaOPoO1HIuTewNRIbxX8=
MIME-Version: 1.0
In-Reply-To: <4996B838.2070205@googlemail.com>
References: <4996B838.2070205@googlemail.com>
Date: Sun, 15 Feb 2009 00:45:37 +0530
Message-ID: <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
Subject: Re: RFC: install firmware in a kernel-dependent directory
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 5:55 PM, Michael Riepe
<michael.riepe@googlemail.com> wrote:
> Currently, make firmware_install puts all firmware blobs in
> /lib/firmware. If you have several kernel versions installed, they will
> overwrite each other's files, which may lead to problems if the blobs
> eventually change. I think it would be better to use a separate
> directory for every kernel version, like /lib/firmware/$(uname -r) or
> /lib/modules/$(uname -r)/firmware (the latter is my favorite).
>
> In either case, only a minimal modification in /lib/udev/firmware.sh is
> required to make it look in the new directory first.
>
> Comments?

firmware version depends on hardware version not by kernel (software) version.

So /lib/firmware is absolutely OK.

--
JSR
