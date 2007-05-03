Return-Path: <linux-kernel-owner+w=401wt.eu-S1162043AbXECOmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162043AbXECOmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162046AbXECOmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:42:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:17401 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162043AbXECOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gtHHlaLuzNST/W/LkU/mMjogZetxYZuwgq2WJWz1b58qc26rvDw9vvhc2kk84SiofJiCNsOa1bhw9lC6r+q/cHgAXfBCrOy/6n1HK8owk24QSILxo0C9ww+maX25Ek7zBCi+ZTf4b/wiSjyEUrANC6Zy34YS2lw9i4RmYKYpD3k=
Message-ID: <4639F4B1.2080606@gmail.com>
Date: Thu, 03 May 2007 16:41:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 1/1] Misc: add sensable phantom driver
References: <219403193181341921@karneval.cz> <20070502234956.cdfe31c2.akpm@linux-foundation.org>
In-Reply-To: <20070502234956.cdfe31c2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
>> +static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
>> +	u_long arg)
> 
> Could we please use standard-looking types in this driver?  u32 and u64 and
> things?
> 
> However in this case, as it's an ioctl handler it should be "int" and
> "unsigned long".

actually, according to file_operations struct:

int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);

"*unsigned* int" and "unsigned long" are correct types...

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
