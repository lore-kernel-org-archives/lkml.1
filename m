Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYFXJP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYFXJP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYFXJPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:15:13 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58096 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFXJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:15:12 -0400
Message-ID: <4860BA98.4070909@s5r6.in-berlin.de>
Date: Tue, 24 Jun 2008 11:12:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jonathan Steinert <hachi@kuiki.net>
CC: linux-kernel@vger.kernel.org, Johannes Niess <linux@johannes-niess.de>,
       linux-usb@vger.kernel.org
Subject: Re: USB attached SATA disk idle spindown
References: <20080624045953.GA24600@miyako.sixapart.com> <4860B651.9090104@s5r6.in-berlin.de>
In-Reply-To: <4860B651.9090104@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Johannes recently informed me that he wrote a script which is used like
> a background daemon to stop idle USB disks.  The script uses
>   - "cat /sys/block/${device}/stat" to watch disk activity,
>   - "sdparm -q -C stop /dev/${device}" to stop the motor after
>     longer inactivity.

PS:  I have seen START STOP UNIT with START=0 to be dangerous with some
FireWire firmwares.  (Motor cannot be restarted after that anymore.)
Other firmwares ignore the START bit and look only at the POWER
CONDITIONS field.  I expect various similar firmware quirks in USB land.
-- 
Stefan Richter
-=====-==--- -==- ==---
http://arcgraph.de/sr/
