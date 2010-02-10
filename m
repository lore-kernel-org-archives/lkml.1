Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0BJQGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:06:37 -0500
Received: from smtp.nokia.com ([192.100.122.233]:47754 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab0BJQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:06:36 -0500
Subject: Re: [PATCH v2] class: Free the class private data in class_release
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
       "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1265805169-31315-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1265801743-26079-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1265805169-31315-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 10 Feb 2010 18:05:45 +0200
Message-ID: <1265817945.2006.270.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Feb 2010 16:06:24.0570 (UTC) FILETIME=[FE7339A0:01CAAA6A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 13:32 +0100, ext Laurent Pinchart wrote:
> Fix a memory leak by freeing the memory allocated in __class_register
> for the class private data.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Thanks for finding this. For reference, this was spotted with help of
the great kmemleak tool.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

