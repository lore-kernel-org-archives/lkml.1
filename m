Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZCOC6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZCOC6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 22:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZCOC54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 22:57:56 -0400
Received: from kuber.nabble.com ([216.139.236.158]:60309 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZCOC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 22:57:56 -0400
Message-ID: <22519639.post@talk.nabble.com>
Date: Sat, 14 Mar 2009 19:57:54 -0700 (PDT)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: COW optimization on exec
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Linux kernel uses the COW optimization for fork, so the processes share
the same pages, till on of the processes writes to the page. I was
wondering, if I do a fork and do an exec immediately following the fork,
will the COW optimization still be applied as it is most likely that the new
process is going to write to the shared pages? So doing a COW will not give
much benefit here, if it is done at all. Can anyone clarify if COW will be
applied in such a case, for e.g. a command shell.
-- 
View this message in context: http://www.nabble.com/COW-optimization-on-exec-tp22519639p22519639.html
Sent from the linux-kernel mailing list archive at Nabble.com.

