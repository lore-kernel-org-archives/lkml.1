Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZGWI2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZGWI2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZGWI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:27:59 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:41388 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZGWI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tZ6DbenRQRzasxe01dTARSOrPBATBzvqjkuWF1AmeA2UKexrq6xs5TnbuXxla/7DY6
         Ni1c1uNouYqQdi2UdeAxmdsTlMFuzMhxGL1lucaGQkR4JbD0iw3R4BHJ7qy8S0TzgvOa
         l/WtYz4F6txBJjI7qBQK/lsVAVLyObiUESypY=
MIME-Version: 1.0
In-Reply-To: <d8bd05e00907230108j5efae098vcb683e934138625d@mail.gmail.com>
References: <62.47.75.132.1247818962.wm@webmail.inode.at>
	 <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
	 <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
	 <524f69650907222310h433cfe86vaef63c8ea2e56d56@mail.gmail.com>
	 <d8bd05e00907222324q26b8faa0i2d85f4d7e35d8198@mail.gmail.com>
	 <524f69650907230044u5ab44c59y91bc9b808f5fd6c3@mail.gmail.com>
	 <d8bd05e00907230108j5efae098vcb683e934138625d@mail.gmail.com>
Date: Thu, 23 Jul 2009 03:27:57 -0500
Message-ID: <524f69650907230127i3ce452a1m3edc5bb9b0535b30@mail.gmail.com>
Subject: Re: mounting cifs filesystems not possible
From: Steve French <smfrench@gmail.com>
To: Gerhard Hintermayer <gerhard.hintermayer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 3:08 AM, Gerhard
Hintermayer<gerhard.hintermayer@gmail.com> wrote:
> Sorry, wireshark not installed.
> The strange thing is, that sometimes mounting succeeds. So it
> should'nt be an issue with the root share (unless the server doesn't
> always answer in the same way)

I am looking for the equivalent lines in dmesg in the failing trace to
those that
follow (in your success trace) the line:

fs/cifs/inode.c: CIFS VFS: in cifs_iget

If we do the QFSAttributeInfo (which is optional), the next (and
final) place to fail
is getting information on the root inode


-- 
Thanks,

Steve
