Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbXB1OP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbXB1OP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbXB1OPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:15:55 -0500
Received: from host2.innominate.fta-berlin.de ([141.16.82.35]:45166 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627AbXB1OPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:15:55 -0500
X-Greylist: delayed 1720 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 09:15:55 EST
Date: Wed, 28 Feb 2007 14:47:12 +0100
From: Christopher Meller <cmeller@innominate.com>
To: linux-kernel@vger.kernel.org
Subject: Question on tty line discipline 
Message-ID: <20070228134711.GA8631@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question concerning the line discipline behaviour for serial
devices.
When the line discipline is set via ioctl from  user space to e.g. N_PPP and the userspace program returns without resetting  the line discipline back to N_TTY, the serial device cannot be used (ENODV) until an appropriate  ioctl (to N_TTY) is performed. Is there any reason for the fact that the line discipline is not reset by the kernel , when closing the device. 

Could you please CC me on answers and comments ?


Kind regards,

Christopher Meller



-- 
Christopher Meller
Software engineer

Innominate Security Technologies AG
protecting industrial networks
tel: +49.30.6392-3680
fax: +49.30.6392-3307
Albert-Einstein-Str. 14
D-12489 Berlin
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Joachim Fietz, Dirk Seewald
Chairman of the Supervisory Board: Edward M. Stadum
