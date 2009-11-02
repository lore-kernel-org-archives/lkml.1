Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbZKBWFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbZKBWFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZKBWFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:05:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49234 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbZKBWFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FUZkrelZ343JA+oYtCcN1iT+U9kGQxduDgwy946P+oH46S5O/v6qfqOQFSUvBF99zz
         61S4uM/uBbxBJPOSete8t0KE9mpREeilucADo7DstJ1g5kTJ+AywobYQ0w3+k2bozk+7
         56qpV4khhlU2TJeOw622IvaNWVGro1lLV58Io=
Message-ID: <4AEF57AC.4090704@gmail.com>
Date: Mon, 02 Nov 2009 23:05:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>	 <4AEF53F5.4020107@gmail.com> <dd18b0c30911021402t6c8b9cd4p2e5d5dcad732d0ac@mail.gmail.com>
In-Reply-To: <dd18b0c30911021402t6c8b9cd4p2e5d5dcad732d0ac@mail.gmail.com>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 11:02 PM, Justin Mattock wrote:
> Now with this oom-killer I'm
> hitting this on an imac9,1 with
> gcc (GCC) 4.5.0 20091029 (experimental)

So there is probably a leak in the gcc chain. Does this happen with a
stable gcc version?
