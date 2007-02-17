Return-Path: <linux-kernel-owner+w=401wt.eu-S1750846AbXBQSYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846AbXBQSYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbXBQSYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:24:24 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:54975
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXBQSYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:24:23 -0500
Message-ID: <45D74856.6090900@microgate.com>
Date: Sat, 17 Feb 2007 12:24:22 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: linux-kernel@vger.kernel.org
Subject: Re: serial and tty driver
References: <45D73BF6.000001.30155@pantene.yandex.ru>
In-Reply-To: <45D73BF6.000001.30155@pantene.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> I have a question, what is really difference between serial and tty
> drivers?
> 
> As I understand tty is high level and communicates with user space. 

The serial core implements many of the details of a tty
driver in a common place so that individual hardware drivers
(serial drivers) only need implement the hardware specific code.

This prevents duplicating tty logic in many drivers,
with the possibility of mistakes/inconsistency in the
different tty drivers.

The stand alone tty drivers are mostly legacy code from
the time before serial core that have not been ported
to be a serial drivers.

--
Paul
