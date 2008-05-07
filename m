Return-Path: <linux-kernel-owner+w=401wt.eu-S1765175AbYEGSYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765175AbYEGSYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbYEGSYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:24:07 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:36434 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbYEGSYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:24:05 -0400
Message-ID: <4821F3B7.2090702@krogh.cc>
Date: Wed, 07 May 2008 20:23:51 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I get errors like this after a few minutes of traffic on a Sun Neptune 
10g ethernet card. (with nice 500MB/s throughput).

Then the server seems too busy with something, so it doesn't even 
respont to a serial terminal login.

May  7 16:16:33 hest kernel: [  166.948958] niu: niu_get_parent: 
platform_type[1] port[3]
May  7 16:16:33 hest kernel: [  166.949366] niu: 
niu_get_and_validate_port: port[3] num_ports[2]
May  7 16:16:33 hest kernel: [  166.949886] niu: niu_put_parent: port[3]
.. bootup ends here ..
May  7 17:13:54 hest kernel: [ 3670.128178] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting
May  7 17:14:04 hest kernel: [ 3680.108614] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting
May  7 17:14:14 hest kernel: [ 3690.093089] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting
May  7 17:14:19 hest kernel: [ 3695.079254] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting
May  7 17:14:24 hest kernel: [ 3700.073525] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting
May  7 17:14:29 hest kernel: [ 3705.063744] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting
May  7 17:14:34 hest kernel: [ 3710.049918] niu 0000:84:00.0: niu: eth4: 
Transmit timed out, resetting


Any suggestions?

The system is an Ubuntu Hardy (2.6.24-17-server) amd64.

-- 
Jesper
