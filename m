Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbYFIOzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbYFIOzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYFIOzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:55:00 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:37459
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYFIOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:54:59 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 10:54:59 EDT
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: linux-kernel@vger.kernel.org
Subject: Frame buffers and early i2c
Date: Mon, 9 Jun 2008 16:47:42 +0200
User-Agent: KMail/1.9.9
Cc: khali@linux-fr.org, adaplas@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091647.42757.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am in the process of trying out a display connected to a colibri board's 
pxa frame buffer device. The display's power supply is switch through i2c.

In order to use the frame buffer console I have i2c and pxafb compiled in.

By default, the pxafb driver get's initialized before the i2c bus causing the 
display power up to fail.

What do i2c people think about changing the link order here?

What do other frame buffer drivers handle the absence of i2c during early 
boot?

regards,
Uli


-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
