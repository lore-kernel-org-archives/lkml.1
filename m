Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0BYNHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:07:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51047 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0BYNHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:07:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YbHv2qmVMBpr9A2066B5ZRLPXFV2bxdTL3V5wYJzU1egC0503h9/Clplk1DihOLsTK
         RJx31PcIEbILWrARTG+RMPdEOGyse0jNbXLxVp6GvGInaNplDcavFYJHswjtsOsjISWn
         lmG9LNUjnnzLTEhJiPDGJ5qS7ZeMd+IkqD4yg=
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 18:37:37 +0530
Message-ID: <22dbbef21002250507s12664df5q36e50a8f9e0bc3b9@mail.gmail.com>
Subject: QUERY: How to call board specific initialization function before 
	map_io or timer_init
From: viresh kumar <viresh.linux@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: viresh.kumar@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I need to call my board specific initialization routine before
timer_init or map_io is called.
I tried to see that in earlier architectures and found most of
architecture call machine
specific init function from map_io or init_irq or init_machine.

Situation: I need to register my clock framework with
arch/arm/common/clkdev framework
before actually initializing timer. So i can't do this in
"init_machine" as timer_init is called
before that.

Can anybody please help.

regards,
viresh kumar
ST Microelectronics
India
