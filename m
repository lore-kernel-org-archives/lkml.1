Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYI1PyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYI1PyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYI1PsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:48:04 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:10458 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbYI1PsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SkxPqIgqkLY3SdceAy2WckeMfWi7KXJpkR+lbPRSQrn5XBVRKXnvJwhOqSULKxJLx+
         3jjGxedeyVx6/k+9ax53RK5jn0r74IG4NX7LYLKefRhXcWS2HGVP3/yReC5AzX5iOY+I
         i+qdK5PLI2Ot80cVLztDntJhTecm9uG/dzqA8=
Message-ID: <c384c5ea0809280847p6a7d2e9as1b2454142751a468@mail.gmail.com>
Date: Sun, 28 Sep 2008 17:47:59 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: scatterlist.c or dma_map_sg() should coalesce?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in 2.6.27+, if I want to create a scatterlist of a large buffer in
virtual memory in a device driver, can I expect the scatterlist and/or
mapping API to provide me with a minimal list, each entry describing a
maximum bus-contiguous piece of memory? (i.e. can I assume coalescing
is done for me?).

In 2.6.24, dma_map_sg() *may* coalesce, but doesn't do so for my
platform, so for optimal DMA transfers the device driver needs to
coalesce the list entries.

Regards,
-- 
Leon
