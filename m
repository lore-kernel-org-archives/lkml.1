Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZEQRKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZEQRKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 13:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZEQRKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 13:10:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:34290 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZEQRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 13:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IiqIErmb+yHrGCWXe+iNMcGSSKcLkIwNhtmbSrp9SgwvX6kw0lnMXJi1V6M3l2lkqn
         II9y4EmF+IJisoFIsXYBU19wFHkbPWyqKFZ1NHm74ghVQjjDwSfxg3uEV7vB1THong6x
         hK8GXPmtlW/zeE0xoVn47X2hTAuInrINfhcJs=
MIME-Version: 1.0
In-Reply-To: <4a4634330905170740m180f451dg9e16a3886f2af298@mail.gmail.com>
References: <20090516162813.GA18098@nb-core2.darkstar.lan>
	 <20090516205558.GA20346@nb-core2.darkstar.lan>
	 <20090516221331.0a456cbb@tlielax.poochiereds.net>
	 <4a4634330905170740m180f451dg9e16a3886f2af298@mail.gmail.com>
Date: Sun, 17 May 2009 19:10:00 +0200
Message-ID: <68676e00905171010r73036097x913629a2db20034d@mail.gmail.com>
Subject: Re: [linux-cifs-client] Re: [2.6.30-rc6] cifs_close: NULL pointer 
	dereference
From: Luca Tettamanti <kronos.it@gmail.com>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 4:40 PM, Shirish Pargaonkar
<shirishpargaonkar@gmail.com> wrote:
> On Sat, May 16, 2009 at 9:13 PM, Jeff Layton <jlayton@redhat.com> wrote:
>> On Sat, 16 May 2009 22:55:58 +0200
>> Luca Tettamanti <kronos.it@gmail.com> wrote:
>>
>>> On Sat, May 16, 2009 at 06:28:13PM +0200, Luca Tettamanti wrote:
>>> > Hello,
>>> > I just hit a NULL pointer dereference in cifs_close while accessing a file on a
>>> > remote Samba shared directory.
>>> [...]
>>> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>>> > IP: [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
[...]
> Does this happen inspite of the patch 90e4ee5d311d4e0729daa676b1d7f754265b5874

Yes, I was running 2.6.30-rc6, which contains that commit.

Luca
