Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbYEYUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbYEYUYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbYEYUYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:24:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:43017 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbYEYUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=hOAxZsJolwbTUPtg3dsskOIwkB7+lwghBWllsDsMFvBCMsVr6zct9cI6KroyL9VenlDCzKDcTfHRxUwPbuz1lU8OVV4YGRoBT0obml2iZ37Xezgk/n4NZC+hQiYWyF/9iGqJQV3jwKeYrxnYfOJR5u6BcZKyDq2g35oC4SWDW6U=
Message-ID: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
Date: Sun, 25 May 2008 16:24:13 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: 2.6.26-rc3 - appletouch resume "incomplete data package"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 16de01af58e7a820
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This appears to be a regression since 2.6.25.  After resuming, I get:

    appletouch: incomplete data package (first byte: 2, length: 4).
    appletouch: incomplete data package (first byte: 2, length: 4).
    appletouch: incomplete data package (first byte: 2, length: 4).
    [...]

And the touchpad doesn't work.  This is on a first gen MacBook.  I
didn't see any changes to the driver itself in that timeframe.
Anyone have ideas, or should I try a bisect?

-- 
Bob Copeland %% www.bobcopeland.com
