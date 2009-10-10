Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbZJJNCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbZJJNCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 09:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761005AbZJJNCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 09:02:10 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49765 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760522AbZJJNCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 09:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=fsspQCkcQLnfNi1ZHVsvr7lXdrrT1fSq3IGlLhkSD4UzF+fm56Sdv+2QuA+nLv987m
         KyMOmSoqJooAXgoLy8xKn6A0mvDDS/EHLIom7TbYNid7SI0+eOsGZrganAeCznIzRmKI
         PpeliC39gquF0xQcVutm5kYi4BUPpcf29DHIA=
MIME-Version: 1.0
Date: Sat, 10 Oct 2009 15:01:33 +0200
Message-ID: <b2cc26e40910100601q7aed04acjcc9973ef06e6458f@mail.gmail.com>
Subject: Enable syn cookies by default
From: Olaf van der Spek <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm forwarding Debian feature request #520668.

Could syn cookies be enabled by default?

AFAIK syn cookies only get send when the half-open TCP connection
queue is full. So stuff like window scaling should work fine in normal
situations.

Speaking of which:
When the half-open TCP connection queue is full and syn cookies are
enabled, you get a message like "kernel: possible SYN flooding on port
2710. Sending cookies."
However when syn cookies are disabled, you don't get any message (in
kern.log), although connections to your server are timing out.
Could such a message be added?
Maybe with a suggestion to increase the size of that queue or to
enable syn cookies.

Greetings,

Olaf

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=520668
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=520667
https://bugs.launchpad.net/ubuntu/+bug/57091
