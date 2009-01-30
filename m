Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZA3NKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZA3NKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZA3NKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:10:23 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54761 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbZA3NKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:10:22 -0500
Message-ID: <4982FC39.7080308@euromail.se>
Date: Fri, 30 Jan 2009 14:10:17 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joon Young Shim <dofmind@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] input: Add a detailed multi-touch finger data report
 	protocol (rev2)
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>	 <1233138229-12489-2-git-send-email-rydberg@euromail.se>	 <1233138229-12489-3-git-send-email-rydberg@euromail.se>	 <1233138229-12489-4-git-send-email-rydberg@euromail.se>	 <1233138229-12489-5-git-send-email-rydberg@euromail.se>	 <1233138229-12489-6-git-send-email-rydberg@euromail.se>	 <1233138229-12489-7-git-send-email-rydberg@euromail.se> <4e1455be0901292210t793c942cg5776079ecc99080e@mail.gmail.com>
In-Reply-To: <4e1455be0901292210t793c942cg5776079ecc99080e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LSt8V-00005g-41.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1LSt8V-00005g-41 24cf89511a659f99ddfd1bbb90d7cd20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joon Young Shim wrote:
> 2009/1/28 Henrik Rydberg <rydberg@euromail.se>:
[snip]
> 
> Hi Henrik,
> 
> Sorry for multiple posts.
> 
> I want to know how calculates touch coordinates at user space using a
> set of ABS_MT.
> If i do dual touch, can i get correct two coordinates through ABS_MT report?

The coordinates for the two fingers are sent from the driver in sequence
as two separate finger packets. What then happens with it depends on the
kind of application. For normal desktop usage, the packets are read from
the input device by the multitouch X driver (a modified version of the
synaptics driver), which does finger matching and transforms the
messages into gestures, reported as X events. It is of course also
possible to read the input device directly. It goes without saying that
further development is needed before the multitouch X driver hits the
repos, but none of this can really become reality without basic support
in the kernel.

Henrik
