Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbXEJI4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbXEJI4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXEJI4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:56:23 -0400
Received: from mail.sjtu.org ([202.120.5.34]:49944 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756158AbXEJI4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:56:20 -0400
Subject: Re: [PATCH 2/3] v4l: saa7134: enable ir-remote for 10moons TM300
	card
From: Tony Wan <wankai@sjtu.org>
To: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
Cc: mchehab@infradead.org, michael@mihu.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1178777673.3120.6.camel@gnome.local>
References: <1178766248.29993.41.camel@wankai.sjtu.org>
	 <1178777673.3120.6.camel@gnome.local>
Content-Type: text/plain
Date: Thu, 10 May 2007 16:54:21 +0800
Message-Id: <1178787271.2337.12.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nickolay:
Thanks for you suggestion!

On Thu, 2007-05-10 at 10:14 +0400, Nickolay V. Shmyrev wrote:
> Size of 256 is not required. You've just selected incorrect keymask,
> that's why you have so big values. Look through your values, in the
> upper 4 bits only two bits are used - 0x80 and 0x10. So you should
> probably use mask_keycode with 0x47800000 instead of mask_keycode =
> 0x7f80000. Or even smaller mask. Include only bits which change the
> values, nothing more.
> 

The key codes confused me for some time and now I get solutions. I'll
change the mask value and calculate the new codes later.

Best regards.


