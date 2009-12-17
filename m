Return-Path: <linux-kernel-owner+w=401wt.eu-S1765293AbZLQSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765293AbZLQSGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765007AbZLQSGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:06:50 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35813 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509AbZLQSGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=nC8XYQo3zj9KJ5Nxt0Gvugr17/umkQQwA5DxG7dcgLsseUrfRB0JJiBfqV7OfV1tqB
         Zkwa0YSIYLC+50hyG+cVX3CjGFV8zQfTjnGRLfKfSWCT5pVLbRtaiukWSedSEvk4J9vk
         WdtVl9SlrKhhy9N9fNDZ+2yogm78iHYatU1t4=
MIME-Version: 1.0
From: Rafael Almeida <almeidaraf@gmail.com>
Date: Thu, 17 Dec 2009 16:06:28 -0200
Message-ID: <6de6b1650912171006j2ac942ay1f31286a05248433@mail.gmail.com>
Subject: On the workings of mmap
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I have been studying the mmap function and it seems like when I
map an sparse file, that the parts of the file that have nothing are
defined as 0 when I access them through the address space returned by
mmap. Is that luck or is it defined to be this way? My only source of
information was debian's manpage on mmap that didn't seem to talk
about sparse files at all.

[]'s
Rafael
