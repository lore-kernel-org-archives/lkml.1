Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZISOrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZISOrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 10:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZISOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 10:47:22 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39996 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZISOrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 10:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iLCFTzzK+VBmuBG9ohdtKhh8+Ye+WkWJmw+vvyTeQtHJzL4osPesgsnAwwFRY2h5ei
         elOFi3o60qSaWWF/hBOrcXKT5Un/GVzX/YS+f+WwX4QygrG2uL3mkzX465bZG45nCT1j
         CpFTQz4XHNomTaR318UcMqzkwWn0tnsLy52eU=
MIME-Version: 1.0
Date: Sat, 19 Sep 2009 15:47:24 +0100
Message-ID: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>
Subject: tickless and HZ=1000 throughput advantage?
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tickless kernels, is the general consensus that for non-embedded
systems, selecting HZ=1000 gives slightly more throughput in
particular situations than HZ=100 or 250, due to finer timer
intervals/granularity?

(low HZ used to cause problems with low-rate QoS packet queues when
timer scheduling was selected)

Thanks,
  Daniel
-- 
Daniel J Blueman
