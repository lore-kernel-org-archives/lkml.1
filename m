Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0BWX6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 18:58:35 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:41603 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0BWX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 18:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=G8y7xw7fKHL1Ah8W90DdjPwhN8aMsvu5mmI//KvoZx9+ZsDCbAeXgUCSOYVoJ5APQH
         jA83UArENtO7wer3nqXp7ffs8sguQeF2rzUhp7+Sy7QuA4fugQTdocRpaM3UqueeupN7
         rTMNGK5smbYjdPFlq9SSSMT7U+0iddiggVIWY=
MIME-Version: 1.0
Date: Wed, 24 Feb 2010 00:51:06 +0100
Message-ID: <17cb70ee1002231551r4fa10cddged54f67a17216f55@mail.gmail.com>
Subject: allocation within a range
From: Auguste Mome <augustmome@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'd like to use kmem_cache() system, but need the memory taken from a
specific range.
I think about adding new zone and define new GFP flag to either select
or ignore the zone.
Does it sound possible (then I welcome any hint if you know where to
add the appropriated
test in allocator, how to attach the region to the new zone id), or
slab/slub system is not
designed for this, I should forget it and opt for another system?
August.
