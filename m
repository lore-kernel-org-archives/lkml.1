Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZITIuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZITIuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 04:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZITIuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 04:50:23 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:37948 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZITIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 04:50:22 -0400
Message-ID: <4AB5ECD0.7010903@datenparkplatz.de>
Date: Sun, 20 Sep 2009 10:50:24 +0200
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <4AB59CBB.8090907@datenparkplatz.de> <20090920080728.73bfe2a1@infradead.org>
In-Reply-To: <20090920080728.73bfe2a1@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> can you try the following two things?
> 
> echo 4096 > /sys/block/sda/queue/nr_requests
> for i in `pidof kjournald` ; do ionice -c1 -p $i ; done

I tried this just now, but it doesn't change things much. I can do a
more testing later today.


> I assume you're using CFQ.

Yes, it's CFQ. (see .config of my previous posting)

Filesystem is EXT4.
