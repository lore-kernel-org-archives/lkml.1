Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbZADTFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbZADTFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbZADTEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:04:55 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45148 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbZADTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DB3/C0nYFqSpnatYAqeSyXNHfxkyl4IG4yWXn5gSFnX2QRQFSN6H4mvZmRVlK2fdN4
         uqjJnoWq8fJLG/42+248+Iq+Yq1rjY0f8wZhDMj8X6r05zEw1GeuSUpFbIu2w34YUgva
         F3NAt48aSL17RvKqExhlkeY/8cEg6JVCy1zhg=
Message-ID: <c384c5ea0901041104m31363264qd17d0181865c276@mail.gmail.com>
Date: Sun, 4 Jan 2009 20:04:49 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH V2 00/16] Squashfs: compressed read-only filesystem
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       linux-next@vger.kernel.org, sfr@canb.auug.org.au
In-Reply-To: <49606B7C.7050403@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Kv0C3-0006GU-ES@dylan>
	 <20081028192919.94def38b.akpm@linux-foundation.org>
	 <49606B7C.7050403@lougher.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 4, 2009 at 8:55 AM, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
>> - what are the limitations of squashfs (please add this to the
>>  changelog of patch #1 or something).  Does it support nfsd? (yes, it
>>  does!)  xatrs and acls?  File size limits, entries-per-directory,
>>  etc, etc?
>
> Xattrs and acls are not supported, this is a todo.
> Filesize limits are in theory 2^64.  In practice about 2 TiB.
>
...
>
> Ok.  I'll re-spin the patches against 2.6.28 tomorrow (Sunday), and I'll
> prepare a tree for linux-next.
>

For use cases such as embedded firmware, the limitations are
non-interesting, and the compression savings are very interesting.
Especially where the resulting filesystem has to creep through slow
wires such as half duplex serial links etc.

Have been using squashfs 2.2 up to 3.4 without problems for years, for
distribution of Linux based firmwares into embedded devices.

Many thanks for your continued efforts on mainlining squashfs,

Regards,
-- 
Leon
