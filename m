Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXISQDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXISQDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXISQC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:02:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971AbXISQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:02:58 -0400
Message-ID: <46F1475B.5050107@zytor.com>
Date: Wed, 19 Sep 2007 08:59:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: james-p@moving-picture.com, linux-kernel@vger.kernel.org,
       aarapov@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
References: <200709191454.l8JEsAQO010080@harpo.it.uu.se>
In-Reply-To: <200709191454.l8JEsAQO010080@harpo.it.uu.se>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> On Wed, 19 Sep 2007 14:35:29 +0100, James Pearson wrote:
>> /proc/PID/environ currently truncates at 4096 characters, patch based on 
>> the /proc/PID/mem code.
> 
> Does /proc/PID/mem even work? If I do `strace cat /proc/PID/mem > /dev/null'
> for a known good PID, the first read() from /proc/PID/mem fails with ESRCH,

Of course it does.  Address zero isn't typically mapped.

	-hpa
