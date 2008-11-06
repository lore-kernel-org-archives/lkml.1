Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYKFWkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYKFWkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYKFWkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:40:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:17262 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYKFWkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UPapnLLia45s40PJEZO9jbFbpH1FJWajSF4y1EQXSmS04d3oRLivtSduVVuekjCFMs
         LCKvfFMbxhvWucY/oTHrFP8Y30ox6A519PnUHkAiFUbresGiPJ5zbYHuvs28ttiL6LlK
         dCfInIqTpReXB1TUAegFt6r82D+s9L1FkHLMI=
Message-ID: <2c918050811061439k450bf4baqd02c054022249b35@mail.gmail.com>
Date: Thu, 6 Nov 2008 22:39:59 +0000
From: andy <rootstrap@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: accessing file operations directly in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am dealing with an interesting situation, which I have to access a
serial device driver
from the kernel space. I tried to use sys_open, sys_ioctl ... but
there is a problem
with the file descriptors.  Now, I started using direct calls to the
drivers functions
driver_open, driver_ioctl... passing the *inode from user_path_walk(),
but it doesn't
seem that works right. This serial device is going to be used only
from the other
module that runs in the kernel.

TIA
Andy
