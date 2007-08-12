Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbXHLDat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbXHLDat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXHLDan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:30:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:6469 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXHLDam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=a2vpiRT5PZprcRtlkxml6qzBWvnZ4OJ3q+c08WIuoiF4oZmJpf02GO1j+m9oWMTGbd4cz1TTApetRbQFIDxBobjBo91eHdFEQTFOPqFEsY5t8p1egZHph8VRwZoyHGMgR0O/img3H5jawi6MyKCw5hjIY2Zhq5nzpcZRHWsskOU=
Message-ID: <a56dfcf00708112030j7a96b8a8m286e270c36362976@mail.gmail.com>
Date: Sat, 11 Aug 2007 23:30:39 -0400
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: reset during bootup - 2.6.23-rc2 (git d23cf676)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This one is going to be fun, since it's a hard reset back to bios, no
OOPS or anything shown.  It may be about the time RadeonFB kicks in,
but it's impossible to tell.  I'd guess 15-20 lines into dmesg.

I'm in the process of bisecting, currently 94c18227..d23cf676.

Any guesses of a specific patch to check?
