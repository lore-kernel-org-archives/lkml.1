Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXIWW15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXIWW15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbXIWW1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:27:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:34646 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbXIWW1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=TLpW0g9Ez6A2xmswSm9eYxm04IYbRJw6/9UoDpZWqmt9nrxvUgKOZYk84yDoTTHvYvAnvrhgFIXV3WMhv/WM2SvdC4PkAbOICONLVoUV2lJOEX9T3RRDmJbrqiU0Ko7Et9QE474W4CPNKUrawEr0eX+gxm5ctmhaGBs9vDKjLes=
Date: Mon, 24 Sep 2007 00:25:13 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Hector Martin <hector@marcansoft.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coding FATX support for 2.6
Message-Id: <20070924002513.f11d1546.diegocg@gmail.com>
In-Reply-To: <46F6D1C3.2070208@marcansoft.com>
References: <46F6D1C3.2070208@marcansoft.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 23 Sep 2007 16:51:15 -0400, Hector Martin <hector@marcansoft.com> escribió:

> Most xbox-linux users are stuck using 2.4, since there is no FATX driver
> for 2.6 and the 2.4 one is unmaintained. I've been thinking about
> writing FATX support into 2.6, to finally end this problem (this is
> basically the only thing holding up 2.6 for Xbox Linux distros). While I
> have done a little kernel coding in the past, I've never messed with
> filesystems in Linux and I'm not entirely sure what the best approach
> would be here. I would like to do it in such a way that it can be

FUSE could be an acceptable solution.
