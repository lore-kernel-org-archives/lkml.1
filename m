Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbXK3ATE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbXK3ATE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbXK3ASu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:18:50 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:24679 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760239AbXK3ASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g8Ew1bhIbDjF+VJpN5T/usqmHN/6RcfMbPjpCz1ns0K8tFrA15u76CDbVE6vXZhl5c1xuc4Fb6ue3srXePx+00AGvxP0lIxVYO9LFp/brpr6RKal4jNxEMBIoTRrm6bZLTrU8zJbDxgIvYVFb2soXfL3/YQDaC5rCKD16eEzKAE=
Message-ID: <a10e25a30711291618r69daa63n265d81c18cf1e06f@mail.gmail.com>
Date: Thu, 29 Nov 2007 16:18:47 -0800
From: "Kunal Trivedi" <ktrivedilkml@gmail.com>
To: linuxkernel <linux-kernel@vger.kernel.org>
Subject: Relation between nr_dirty and nr_inactive
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am running older kernel (CentOS 2.6.9-34 SMP) on 32 bit arch. Some
of my systems got hung, while trying to write some data to disk. All
those systems exhibit similar pattern where during this time,
/proc/meminfo suggesting 'Inactive' < 'Dirty'. All of machines have 2G
of physical memory and ~1.5G memory is locked (via mlock).

I tried reading code but could not establish any direct relationship
between Zone->in_active pages vs. per-cpu_page_state->nr_dirty.

Has anybody seen system in this kind of state before ? And are these 2
parameters affect each-other ?

Thanks
-Kunal
