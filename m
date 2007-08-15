Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXHOFhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXHOFhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 01:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXHOFhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 01:37:07 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:41965 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXHOFhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 01:37:05 -0400
Message-ID: <46C290F6.2090309@alcatel-lucent.com>
Date: Wed, 15 Aug 2007 13:36:54 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: do_coredump and O_NOFOLLOW
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 05:36:58.0198 (UTC) FILETIME=[4C07AF60:01C7DEFE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I found that O_NOFOLLOW is used for opened core file in Linux 2.6.10. 
This means the core file couldn't be a symbolic link. However, I want to 
use symbolic link for core file, So I plan to remove O_NOFOLLOW as 
follows, but I'm not sure there are any impacts introduced by the change?

file = filp_open(corename, O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE, 0600);

TO

file = filp_open(corename, O_CREAT | 2 /*| O_NOFOLLOW*/ | O_LARGEFILE, 
0600);

Thanks,
Gavin
