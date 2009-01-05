Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZAESz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZAESz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZAESzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:55:44 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:50557 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbZAESzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:55:42 -0500
Message-ID: <4962579E.9080901@euromail.se>
Date: Mon, 05 Jan 2009 19:55:26 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       jg@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: Add a detailed multi-touch finger data	report
  protocol (rev2)
References: <495804B1.10300@euromail.se> <20090105035758.GA28664@dingo.redhat.com>
In-Reply-To: <20090105035758.GA28664@dingo.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LJubz-00011c-7w.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LJubz-00011c-7w 1ea8f0ca5572aeb29674d6c4c6d5c54b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hutterer wrote:
[...]
> 
> To clarify: the MT_TOUCH_MAJOR is to track a touchpoint over time, and the
> BLOB_ID to compile a arbitrarily shaped touchpoint within the same event?

MT_TOUCH_MAJOR is the major size of the touching object, or "pressure" in
case the size of the approaching object (MT_WIDTH_MAJOR) is not available
to compare the size to. The touch and position packets are sent to the
multitouch X driver, where the actual finger tracking takes place. Thanks
for the chance to clarify this.


> Would it make sense to allow specification of a blob as bit/bytemask? There
> are a few devices that can do detection of multi-color non-rectangular
> touchpoints, especially camera-based systems. Limiting these to a sequence of
> rectangles means dropping information that may be useful for certain tasks
> (e.g. fingerprint detection).
> OTOH, a rectangle as bounding box with an accompanying (optional) bytemask can
> pass this data on to prospective clients.

Very interesting idea, although I believe it is beyond the scope of the
current patch.

