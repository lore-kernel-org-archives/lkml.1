Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbXL3Hdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbXL3Hdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXL3HdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:33:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:34905 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbXL3HdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=inqwMW9Qtk4omK+E6qTdu1bm4WHLQ5HlEq2NBDk16fgfrbnc/zC5T7xEN9EO3euNq95JZ4qGroWfVtMNJXKCyS7o1Bc3QIR1DBqgU8YHotEvEUedCUTvHBGrcQ3o2s2mnFfY413RkuSa5GbvQ9o7ADtpnoONWGiEEZrQGuraZX8=
Message-ID: <44c63dc40712292332s4a2e7e4aief37a2dbdd03fc21@mail.gmail.com>
Date: Sun, 30 Dec 2007 16:32:42 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: linux-mm@kvack.org
Subject: why do we call clear_active_flags in shrink_inactive_list ?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.23's shrink_inactive_list function, why do we have to call
clear_active_flags after isolate_lru_pages call ?
IMHO, If it call isolate_lru_pages with "zone->inactive_list", It can
be sure that it is not PG_active. So I think It is unnecessary calling
clear_active_flags. Nonetheless, Why do we have to recheck PG_active
flags wich clear_active_flags.

If it is right, which case it happens that page is set to be PG_active ?

-- 
Thanks,
barrios
