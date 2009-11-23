Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZKWQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZKWQTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZKWQTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:19:52 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54324 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbZKWQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:19:51 -0500
Message-ID: <4B0AB60B.2030006@s5r6.in-berlin.de>
Date: Mon, 23 Nov 2009 17:19:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Mario Limonciello <superm1@ubuntu.com>,
       linux-input@vger.kernel.org, linux-media@vger.kernel.org,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
In-Reply-To: <m36391tjj3.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> Event input has the advantage that the keystrokes will provide an unique
>> representation that is independent of the device.
> 
> This can hardly work as the only means, the remotes have different keys,
> the user almost always has to provide customized key<>function mapping.

Modern input drivers in the mainline kernel have a scancode-to-keycode
translation table (or equivalent) which can be overwritten by userspace.
The mechanism to do that is the EVIOCSKEYCODE ioctl.

(This is no recommendation for lirc.  I have no idea whether a
pulse/space -> scancode -> keycode translation would be practical there.)
-- 
Stefan Richter
-=====-==--= =-== =-===
http://arcgraph.de/sr/
