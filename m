Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbYBLI4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbYBLI4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYBLI4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:56:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44505 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbYBLI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:56:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B15F1F.3060704@s5r6.in-berlin.de>
Date: Tue, 12 Feb 2008 09:55:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] firewire: fw-sbp2: don't add scsi_device twice
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.2ef253adcedcb9ea@s5r6.in-berlin.de> <47B083A0.4090900@redhat.com> <47B0A50D.6060807@s5r6.in-berlin.de>
In-Reply-To: <47B0A50D.6060807@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Jarod Wilson wrote:
>> Was the spurious __scsi_add_device simply failing, or was it causing
>> other problems as well?

> SCSI core looks up whether the scsi_target and the scsi_device already
> exist.  If so, __scsi_add_device succeeds (there should also be a log
> message "scsi scan: device exists on %s\n") and returns the pointer to
> the existing scsi_device.

PS:  This behavior is undocumented and we shouldn't rely on it.
-- 
Stefan Richter
-=====-==--- --=- -==--
http://arcgraph.de/sr/
