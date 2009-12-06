Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZLFJXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZLFJXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZLFJXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:23:41 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43378 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbZLFJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=B0coc8oi4vTytG33Nggghs41eA1ZsnH5GEN8X7jQHLtYpOwMwR+ee7V4YTSxPmgG9Z
         SLA5gheMXQeHoB+mSXe2G+w0o8ROH5oZXAcXcF41SbrXoZH2ZHegw0e6NhwroYDNMydl
         WHfIzXyCHycZmpMiqkAF+suZs4gyq8yX9kAO8=
Message-ID: <4B1B781C.3060307@gmail.com>
Date: Sun, 06 Dec 2009 10:23:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Emese Revfy <re.emese@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 11/31] Constify struct file_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198C43.50205@gmail.com> <4B19A333.5080103@gmail.com> <4B1A6B28.2020501@gmail.com> <4B1B193B.7080609@gmail.com>
In-Reply-To: <4B1B193B.7080609@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2009 03:38 AM, Emese Revfy wrote:
> Jiri Slaby wrote:
>> Apart you CCed hundreds of people
> 
> I looked up the maintainers of the patched files from the kernel sources
> because I didn't know a better way to let everyone affected know.

Well, if you had per subsystem patches, you would Cc only relevant
people per patch.

>> and mixed thousand things together into one patch,
> 
> I thought that the best way is to have one patch contain changes for
> a single structure type only.

The problem is that probably nobody will pick them up. Or you would need
to collect Acks from all participants and run with these to Andrew
Morton. Then it's up to him if he wants to merge them. If you split
them, you can ask concrete maintainers for a merge.

-- 
js
