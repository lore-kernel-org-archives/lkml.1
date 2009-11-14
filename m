Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZKNJQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZKNJQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZKNJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:16:08 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64160 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZKNJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kVy0mV/ATIBF78wHauSnTVeAgEZQPyERoqufmrVDywAsz8vMVkYz5ypsTTh9fH2gzL
         hUE9e83vMLfJ5vSVjg4OnY/eL2c59iJuxcr+v80OE5GAtUQhWsL9xMjXCIQ+lZAbFQq8
         FwgZ3xb2TxYvFCvLzkcPZYrYnWa296pFPHDYg=
MIME-Version: 1.0
Date: Sat, 14 Nov 2009 14:46:13 +0530
Message-ID: <26b26d180911140116k370ee274l333e54858c66e3a1@mail.gmail.com>
Subject: trying to add rfkill support to realtek driver for rtl8192e
From: saurav barik <saurav.barik@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to implement rfkill support for realtek driver for rtl8192e.
The realtek driver we are using is very much similar to the one in
kernel 2.6.31.5(linux-2.6.31.5/drivers/staging/rtl8192su).
In order to use "wiphy_rfkill_set_hw_state", I need "struct wiphy"
which in turn is a part of "ieee80211_hw" structure.
However ieee80211_hw is not used in our driver.
Is the usage of 80211_hw is obsolete?
Without having the above structure how can I use the rfkill interface?

Anybody aware of this, please share some pointers.

Thanks for your time.

Regards,
Saurav
