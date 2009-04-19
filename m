Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZDSQRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZDSQRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760310AbZDSQRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:17:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:35083 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbZDSQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EcDO5UuPijrkmnNnNUwnTARQVlj/KPbXUhHc1MRosJm1QkXbLixY7vyf0B7ChpYQcn
         OcddiCJm1y4NH2g+ewkLEmMv9pKKZghT9qn1ThYOQsNqc+bePCNinn54t+nTgTtj5vI7
         47H3xmmqASC1EPcacjN9XZDmwfc9LVJNfFfWg=
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 18:09:44 +0200
Message-ID: <c384c5ea0904190909i1b5ec8car615fdc76e302b871@mail.gmail.com>
Subject: splice_read() for device drivers?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I have a device driver for data acquisition that currently exposes a
character device. The device driver performs DMA transfers directly
into/from user space on read/write().

If I want the driver to support splicing, must I implement
splice_read/write() ops? Can I make them directly DMA into the splice
pipe buffer pages?

I found no current implementation of splice_read/write(), except for
filesystem drivers.

Is there a write-up on this or a reference implementation? Any work in
progress for LDD4 or such?

Regards,
-- 
Leon
