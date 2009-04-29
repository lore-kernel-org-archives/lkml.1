Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZD2MnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZD2MnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZD2Mmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:42:49 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50082 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZD2Mms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:42:48 -0400
Message-ID: <49F84B38.7080308@suse.de>
Date: Wed, 29 Apr 2009 18:12:32 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: String conversions
References: <524f69650904281145v6c94094er7c31dacff3cec0b4@mail.gmail.com> <38c3c4860904290533g1a62ed85y12005733d5599c33@mail.gmail.com>
In-Reply-To: <38c3c4860904290533g1a62ed85y12005733d5599c33@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Steve French <smfrench@gmail.com> wrote:
> 
> In looking at various patches for more accurately sizing the required
> buffer needed for conversions to UTF-8, the following question came up
> more than once.
> 
> Functions which do string copying often null terminate the target
> string (single byte of \0), and size strings one byte larger than
> their string name (for UCS-2 this does not work since the null
> termination is two bytes). � Are there local nls codepages in Linux
> kernel which require double null termination (e.g. DBCS asian code
> pages), and if so how do you tell which ones require "double null
> termination?"

A look at fs/nls and supported charsets suggests that the linux kernel
does not support a pure double-byte charsets. Some of the supported east
asian charsets seem to be a superset of ASCII (for e.g TIS 620, Big5)
and only non-ASCII characters are expressed in 2 bytes.


Thanks,

-- 
Suresh Jayaraman
