Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYCFNkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYCFNkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYCFNj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:39:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:33300 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYCFNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=a1DJq3S/AHmbzfij1hjzludMkaVIC6K5ZQJxKz1GPu1IPwO0dDexr+MaVN2xEkcBuJmiXVr2AC3gr9O4SU8dFyNECucMduFe+VKZm0WQ+regbb/OJXoS/zWMig0fBzgTfGxQ9BZTFNtLwR2BRI1+gyWVSlWaR7V07r6LQh5Eo0o=
Message-ID: <d65f34950803060539y284910bck277310280ef4c009@mail.gmail.com>
Date: Thu, 6 Mar 2008 19:09:57 +0530
From: shri <shree0007@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: mmc card detection
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   My proto board does not have a mmc card detect line to the mmc controller.

   So, I have to insert the card before i insmod the mmc drivers.
   If i change a card i have to rmmod and insmod the driver.

   I would like to know is there anyway i can make mmc to free up all the
   resources for the removed card. entries and reinitialise the new
card inserted if any
   without rmmod or insmod.

   I thought of using mmc_remove_host and mmc_add_host in the driver
which could be triggered by
   an application through sysfs entry.


   Are the calls mmc_remove_host and mmc_add_host the correct call to
use in this case?


Regards,
shri
