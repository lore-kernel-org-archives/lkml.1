Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZGULih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZGULih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZGULie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:38:34 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:49518 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbZGULid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:38:33 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device node
References: <87zlb1u592.fsf@tac.ki.iif.hu>
Date: Tue, 21 Jul 2009 13:38:33 +0200
In-Reply-To: <87zlb1u592.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Sat,
	18 Jul 2009 22:04:57 +0200")
Message-ID: <87iqhmcll2.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
> keeps increasing on each replug.

I forgot to stress that the number increases if I use the device
before unplug only.  Simply yanking/replugging the connector makes the
same device number disappear/reappear.  Maybe pppd does something
special, which makes the old device "stick", even though pppd dies at
the end of the session.
-- 
Feri.
