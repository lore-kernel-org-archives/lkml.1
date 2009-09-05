Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZIEItE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZIEItE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 04:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbZIEItD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 04:49:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57850 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZIEItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 04:49:02 -0400
Message-ID: <4AA225FC.7080601@cs.helsinki.fi>
Date: Sat, 05 Sep 2009 11:49:00 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mcgrof@gmail.com
Subject: Re: [PATCH v3 4/5] kmemleak: fix sparse warning over overshadowed
 flags
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com> <1252111494-7593-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252111494-7593-5-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> A secondary irq_save is not required as a locking before it was
> already disabling irqs.
> 
> This fixes this sparse warning:
> mm/kmemleak.c:512:31: warning: symbol 'flags' shadows an earlier one
> mm/kmemleak.c:448:23: originally declared here
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
