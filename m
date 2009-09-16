Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZIPM6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZIPM6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZIPM6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:58:51 -0400
Received: from james.oetiker.ch ([213.144.138.195]:60760 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZIPM6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:58:50 -0400
Date: Wed, 16 Sep 2009 14:58:52 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: vgoyal@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: io-controller: file system meta data operations
Message-ID: <alpine.DEB.2.00.0909161445440.11232@sebohet.brgvxre.pu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

I am trying to optimize user-experience on a busy NFS server.

I think much could be achieved if the following was true.

  get a response to file system meta data operations (opendir,
  readdir, stat, mkdir, unlink) within 200 ms even under heavy
  read/write strain ...

In the course of my research I also tried the io-controller patches.

My test setup consists of several tar processes keeping a disk busy
by packing and unpacking Linux kernels.

I was able to bring read and write bandwidth into balance by
putting the reading and writing tars in to different cgroups.

Unfortunately this did not seem to help my goal since meta data
operations do not seem to get treated differently from normal
operations (or maybe even worse?)

Is there a way to get io-controller to help me with this?

cheers
tobi
-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
