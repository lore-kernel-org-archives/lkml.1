Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZJDTRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZJDTRD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZJDTRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:17:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808AbZJDTRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:17:01 -0400
Date: Sun, 4 Oct 2009 16:16:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] i7core_edac and edac_mce
Message-ID: <20091004161604.255340f8@pedra.chehab.org>
In-Reply-To: <20090924192821.7fcffc80@pedra.chehab.org>
References: <20090924192821.7fcffc80@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed By Arjan, Hidetoshi and Borislav, the edac glue had the
risk of causing dead locks with NMI code. Due to that, I'm submitting
a patch that replaces it to use, instead, a ringbuffer.

I also found a bug at the new edac sysfs methods when more than one memory 
controller were used, and added a small patch to improve error injection
address mask.

Please review.

The entire patch series is available at:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git for_linus

Cheers,
Maur

-- 

Cheers,
Mauro
