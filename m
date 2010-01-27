Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591Ab0A0JgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0A0JgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067Ab0A0JgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:36:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:65321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab0A0JgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uU5jjkgZluIG3llq3YctTkqzp+jfPbnkIp9zwOeqvl0DFE1tXWx/AyJtmFgdsv/j4X
         8eOT/VXeaIo8po6kkEKnG4h7d1bZDqWWYSq+vWIJEj47gL1LxguWDQcQSSaN6Jv+8/Y8
         HHmhgCtubXZhAbP8Mg4FgFlPGcvT6ZWScpkq8=
Message-ID: <4B600901.6090804@gmail.com>
Date: Wed, 27 Jan 2010 10:36:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, joe@perches.com,
       bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com,
       shemminger@vyatta.com
Subject: Re: + drivers-block-floppyc-remove-used-once-check_ready-macro.patch
 added to -mm tree
References: <201001270037.o0R0bS1R032523@imap1.linux-foundation.org>
In-Reply-To: <201001270037.o0R0bS1R032523@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 01:37 AM, akpm@linux-foundation.org wrote:
> Subject: drivers/block/floppy.c: remove used once CHECK_READY macro
> From: Joe Perches <joe@perches.com>

That the macro is used once does not necessarily mean, it should be
removed. Please add more explanation to your changelogs. It should be
something like: "remove the macro as it is totally bogus in that it
changes control flow and we usually do not expect that". For example,
there were alerady few macro incidents in floppy that changed control
flow causing locking imbalances.

-- 
js
