Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYIXBAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYIXBAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 21:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYIXBA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 21:00:29 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:32900 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbYIXBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 21:00:28 -0400
Message-ID: <48D9912A.20303@lwfinger.net>
Date: Tue, 23 Sep 2008 20:00:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Robert Hancock <rwh461@mail.usask.ca>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Logs being spammed with "Unable to enumerate USB device"
References: <fa.dl+pVhW/kcgBFo0dsyPEgn0MhtE@ifi.uio.no> <48D9865B.8080806@mail.usask.ca>
In-Reply-To: <48D9865B.8080806@mail.usask.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> 
> Is this just occurring during bootup? I think this is normal if the EHCI
> driver is loaded after UHCI or OHCI because it causes the device to be
> switched away from the other controller that's trying to enumerate it,
> at least momentarily.

It sometimes happens at bootup, but at other times I will get hundreds
of them in a row in the logs. I have put in some debugging where the
message is triggered, but have not seen any of the flood-type since.

Larry


