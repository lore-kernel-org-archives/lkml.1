Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYHWA40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYHWA40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 20:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYHWA4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 20:56:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:21621 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYHWA4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 20:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H46oIFjvY/e1zwTCx9I0DwUIigi7BTt9/uCt7yBDM72rM/lxWUz6zaTuK/32OQLaeZ
         x9+vtW9oDs5f73bTh7BtKe7GTIvUtgqW0kBEvuaWndOu/oI9Zk8IIi3IMbla/J42uGO5
         cEgvbU4qZYqt1N1p+clfHbJrrcMq4KOGSdI8A=
Message-ID: <f17812d70808221756w21d82dafl25b7927575d91571@mail.gmail.com>
Date: Fri, 22 Aug 2008 20:56:16 -0400
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
Cc: "Pavel Machek" <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       "Samuel Ortiz" <sameo@openedhand.com>
In-Reply-To: <74d0deb30808220429y73daf8cbg4b593516f05f7302@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
	 <20080822090318.GB6542@atrey.karlin.mff.cuni.cz>
	 <f17812d70808220232o7976680fkbb34528c4b7b000f@mail.gmail.com>
	 <74d0deb30808220429y73daf8cbg4b593516f05f7302@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead of allocating/adding the platform subdevices manually in
> da903x_add_subdevs, couldn't you use the MFD (multi function device)
> infrastructure that seems to be intended for this case? Also, I think
> that the da9030 base driver would then better fit in drivers/mfd, not
> drivers/i2c/chips (didn't Jean Delvare himself state that ideally
> drivers/i2c/chips should be empty?).

Actually, I don't mind keep it anywhere. The intermediate
platform_device is what I'd like to avoid mostly. Using my
own simple logic allows me to do that later.
