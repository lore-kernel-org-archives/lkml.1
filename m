Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbZAUIXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbZAUIXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZAUIX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:23:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56143 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZAUIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:23:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4976DB7B.9030802@s5r6.in-berlin.de>
Date: Wed, 21 Jan 2009 09:23:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ionut Leonte <garglkml@gmail.com>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.28 changes in-kernel name for UVC device ?
References: <200901201349.33707.ionut.leonte@gmail.com> <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com> <49760649.8000800@s5r6.in-berlin.de> <200901210523.01282.ionut.leonte@gmail.com>
In-Reply-To: <200901210523.01282.ionut.leonte@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ionut Leonte wrote:
> On Tuesday 20 January 2009 19:13:45 you wrote:
>> only certain types of FireWire cameras cause respective uevents and thus
>> autoloading of the special-purpose driver video1394.  Ergo, Ionut's
>> userland has a configuration somewhere which loads video1394 explicitly.
> 
> It's most likely related to my kernel being monolithic -

Ah, right; I keep forgetting that there is also Y besides M.  :-)
Anyway, the best course of action is to get the udev device naming rules
fixed.

I suppose the simplest course of action would be to add the expression
SUBSYSTEM=="video4linux" to the v4l rule.  Then it won't be applied to
ieee1394 devices.
-- 
Stefan Richter
-=====-==--= ---= =-=-=
http://arcgraph.de/sr/
