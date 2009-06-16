Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZFPKDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZFPKDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZFPKDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:03:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:10592 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbZFPKDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cbiNX5NKOnyaLIo0X3eKotUgvUULl3jRZEt9PciyrQjFNc3BDBP9wC9hsrBWbMcDc+
         +gcAs+U/xnyptgeeUV6kNWionE8/ppNglOFf0Br/SE9B255WHuHT8xUSSbL0hjWCgtmI
         03pt3++Z3gghjOsxJ6qRq5AXzFoZnBs/08nqs=
MIME-Version: 1.0
In-Reply-To: <200906151304.16416.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<1244980878-2124-6-git-send-email-vapier@gentoo.org> <200906151304.16416.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 16 Jun 2009 06:03:03 -0400
Message-ID: <8bd0f97a0906160303j7b72ca8ag83dc9a3ab1516406@mail.gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:04, Arnd Bergmann wrote:
> On Sunday 14 June 2009, Mike Frysinger wrote:
>> The Blackfin port only implemented an optimized version of the
>> csum_tcpudp_nofold function, so convert everything else to the new
>> generic code.
>
> Have you tested this one well? I was as careful as possible with the
> version I added, but it was basically only tested on microblaze, which
> has a different endianess from blackfin. Some areas of the code may be
> sensitive to this.

networking still worked on my BF537-STAMP, but that isnt a very big
test.  i'll keep it locally until we can regression test it harder.

although these kind of issues sounds like a good reason to add some
internal testing code for people to optionally enable ... make sure
things work across endians/bit sizes/assorted changes & improvements
...
-mike
