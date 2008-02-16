Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbYBPQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbYBPQya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYBPQyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:54:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39067 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYBPQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:54:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B7153A.6020802@s5r6.in-berlin.de>
Date: Sat, 16 Feb 2008 17:54:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: marcin.slusarz@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>, Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH] ieee 1394: be*_add_cpu conversion
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-3-git-send-email-marcin.slusarz@gmail.com>
In-Reply-To: <1202857582-15450-3-git-send-email-marcin.slusarz@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

marcin.slusarz@gmail.com wrote:
> replace all:
> big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);

Committed to linux1394-2.6.git.  Thanks,
-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/
