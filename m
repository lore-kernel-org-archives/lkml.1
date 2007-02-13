Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXBMTBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXBMTBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbXBMTBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:01:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:22424 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXBMTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:01:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=L7CJhc5QOgSEpazG6p9eA7GdvSVlMtjwSazZ6C77+GJonuFSFy6kdmzUI+bOl/h5Tl3ZSH7W80ePvJdaS3SH9frLtBtxQ3MVe6SDl58OvubyOqxHFZbYN+GN/qTZWEkO9T40kh4TqPNw2hZcU91ykyrR1uEEMb7vphF+qFnHuJQ=
Message-ID: <45D20CFA.7020008@gmail.com>
Date: Tue, 13 Feb 2007 11:09:46 -0800
From: Jeff Carr <basilarchia@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: "Martin A. Fink" <fink@mpe.mpg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de> <p73abzji9xi.fsf@bingen.suse.de> <200702121737.12882.fink@mpe.mpg.de>
In-Reply-To: <200702121737.12882.fink@mpe.mpg.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/07 08:37, Martin A. Fink wrote:

> :~> strace -c -T -o trace.out dd if=/dev/zero of=test.txt bs=10MB count=200
> 
> 200+0 Datensätze ein
> 200+0 Datensätze aus
> 2000000000 bytes (2,0 GB) copied, 52,8632 seconds, 37,8 MB/s

You might want to check the raw write & read speed to the device
without a filesystem. Also, your previous email didn't include xfs.
xfs has very good sustained write performance.

dd if=/dev/zero of=/dev/sdX bs=10MB count=200
dd of=/dev/null if=/dev/sdX bs=10MB count=200
