Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZBQLis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZBQLis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZBQLii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:38:38 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:62834 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZBQLig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VfKCsGyG3DThFiQoZp5BYZ6zk8XwY5wHSjhr3BtTDywSAhULa7s/mbv6jj/eZNY80/
         95E8+/BSwPy7rzozldC2KHZg0d6A0xOQDlhyLQ18LyDbzcmMjroZ7aIxxriSqkFADcyJ
         aSK7vsZn64nw/eZvmVw2m50GEfcpeVVDASJQY=
Message-ID: <499AA1B5.5090501@gmail.com>
Date: Tue, 17 Feb 2009 12:38:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nye Liu <nyet@mrv.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: modpost: Something amiss with do_hid_entry() - id->bus endianess
 wrong?
References: <20090217045840.GA28536@mrv.com>
In-Reply-To: <20090217045840.GA28536@mrv.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nye Liu wrote:
> i am having problems with endianness on the id->bus value in do_hid_entry().
> 
> i think there is a "TO_NATIVE(id->bus);" missing in scripts/mod/file2alias.c:

Definitely! Good spotting, thanks.

Could you try the patch I posted a minute ago?
