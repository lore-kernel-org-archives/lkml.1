Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZLVBOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZLVBOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZLVBOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:14:34 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36254 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZLVBOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CGQL2u7FdD0i+vvtJkJDlw3/mVzvOlKOOtRwK9lQuOVqM82JpPp2CJqDn+pOOTOGO4
         dDu4/5dxV7q1u7mq4bFgBrgo0lix1oVkAjpsFiSs0aMcUSg5dYsLu/mXmWmj+o40uRsU
         fr3FgE+xoPbABsDoHvtCN+/S2BkOCBElkNEOo=
Message-ID: <4B301D76.4070707@gmail.com>
Date: Mon, 21 Dec 2009 19:14:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Philip Wernersbach <philip.wernersbach@gmail.com>
CC: linux-kernel@vger.kernel.org, tytso@mit.edu, Pavel Machek <pavel@ucw.cz>,
       Richard Holden <aciddeath@gmail.com>
Subject: Re: [PATCH] ext2/3 as ext4
References: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>	 <20091207190947.GF27692@thunk.org> <def8f7750912161642v16dd7bbflaf78bd0d231af68d@mail.gmail.com>
In-Reply-To: <def8f7750912161642v16dd7bbflaf78bd0d231af68d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 06:42 PM, Philip Wernersbach wrote:
>> Why the open coded strcmp?
> strcmp is a C standard library function, not a C builtin, thus it
> can't be used in the kernel.

Um, we do have strcmp, memcmp, and most such common library functions in 
the kernel..
