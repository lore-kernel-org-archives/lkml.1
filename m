Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbZGWGKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbZGWGKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZGWGKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:10:11 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:44497 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZGWGKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nD+ZG7YegXP8s6rPpCsoekmt8gf1h0qtu0Kv0OLKs/dFCHUph0nYpNE/pBZdW7k1Mx
         WpNZUNsK4fuQxSOkXBk61aajjZi8i1KIx8StSm+IDmZGeNF0d1sqmRlDrx57xvQcy70G
         pFCLeNr7Fz4IAicUzDQpqCcnV3I0M2Z1oB/H0=
MIME-Version: 1.0
In-Reply-To: <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
References: <62.47.75.132.1247818962.wm@webmail.inode.at>
	 <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
	 <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
Date: Thu, 23 Jul 2009 01:10:09 -0500
Message-ID: <524f69650907222310h433cfe86vaef63c8ea2e56d56@mail.gmail.com>
Subject: Re: mounting cifs filesystems not possible
From: Steve French <smfrench@gmail.com>
To: Gerhard Hintermayer <gerhard.hintermayer@gmail.com>
Cc: linux-kernel@vger.kernel.org, sfrench@samba.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 12:26 AM, Gerhard
Hintermayer<gerhard.hintermayer@gmail.com> wrote:
> Well this is indeed strange. First I thought the problem was solved
> because I had an old version of mount installed, but the successful
> mount with latest version of mount.cifs was only by chance. I get 1
> successful mount out of ~ 30 tries (each time unloading the cifs
> module). And looking at the source in export.c I discovered, that
> reexporting cifs- mount points is still not supported :-( : This seems
> to be very tricky. If you need more information to track the tainting
> problem down, pls give me a note.

What is kernel version?
What is symptom?

Have you opened a bug against the project bugzilla (bugzilla.samba.org)?

The dmesg (Linux message log) will show certain serious errors, but
enabling additional cifs debugging flags can increase the debug
output. Setting /proc/fs/cifs/DebugData to 1 will cause additional
cifs informational messages to be logged, and setting
it to 3 (“echo 3 > /proc/fs/cifs/cifsFYI”) will also log return codes
from most cifs entry points to dmesg.
One of the most powerful tools for analyzing networking or network
filesystem problems is “Wireshark."
http://wiki.samba.org/index.php/Capture_Packets shows instructions how
to do wireshark captures.

-- 
Thanks,

Steve
