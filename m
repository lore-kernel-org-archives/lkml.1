Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZKNN2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZKNN2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 08:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZKNN17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 08:27:59 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48909 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZKNN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 08:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rYEq9ulxo+5MlY7pJ7jgguoeiNplkEEvpNzA3j2OIm1PowjgIk1aDAUQNLFMXZlcic
         YQ7h4+xifKueayg/qhYLevVvPD0zfybOrYM9pLflaeH5EEYd8zfP62CsSZSvEKKHMVlY
         khb+RmEa9zJhSN1B9ZjLsegn9Zh5gixv1JvGw=
Message-ID: <4AFEB060.80007@gmail.com>
Date: Sat, 14 Nov 2009 14:28:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091112 SUSE/3.0.0-1.1 Thunderbird/3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>
Subject: resume crashes in intel_init_thermal [was: mmotm 2009-11-13-19-59
 uploaded]
References: <200911140403.nAE43CN1016851@imap1.linux-foundation.org>
In-Reply-To: <200911140403.nAE43CN1016851@imap1.linux-foundation.org>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2009 05:03 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-11-13-19-59 has been uploaded to

Hi, resume from ram dies in intel_init_thermal in that kernel:
http://www.fi.muni.cz/~xslaby/sklad/mce_oops.png

The code is cc cc cc cc ... KGDB and KPROBES are off, I don't know where
the pattern may come from.

Does it ring a bell? Any ideas? mmotm 2009-11-01-10-01 was OK.

thanks,
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
