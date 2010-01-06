Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053Ab0AFAnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0AFAnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407Ab0AFAnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:43:51 -0500
Received: from us-mx4.synaptics.com ([12.178.49.178]:24631 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0AFAnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:43:51 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 05 Jan 2010 15:48:50 -0800
From: William Manson <WManson@synaptics.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: Christopher Heiny <Cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 5 Jan 2010 16:45:48 -0800
Subject: RE: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen
 Driver
Thread-Topic: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen
 Driver
Thread-Index: AcqOWHdf4CwthlM3QzG1CDdQ1mm49gAED5uQ
Message-ID: <7B4B50AC280A5E45A42CD2D364A3CE2F2733F75A41@USW-EX2K7-1.synaptics-inc.local>
In-Reply-To: <20100105224051.GA7869@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry -

I'll see if I can get someone in contact with you. I agree with you that patches to extend the existing driver would be preferable. It would probably be someone who is not working on the proprietary binary driver that would have to do the patches as the IP requires that we keep them separated. I wouldn't mind doing that myself as I'm already working on the open source driver for RMI4 over I2C and I have done a few minor things with the current open source kernel PS/2 driver - not patches but changes for minor issues that were for specific customers mostly in the area of configuration. Also, I'm not "tainted" by the proprietary driver - in fact I've never seen the code. I'll discuss with my boss if that's possible.

Regards,
William


-----Original Message-----
From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
Sent: Tuesday, January 05, 2010 2:41 PM
To: William Manson
Cc: Christopher Heiny; Allie Xiong; linux-kernel
Subject: Re: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver

On Tue, Jan 05, 2010 at 01:57:37PM -0800, William Manson wrote:
> Hi Dmitry -
>
> Yes - we are planning on extending support for our new touchpads. As
> far as I know there is a Linux PS/2 driver in the works but I don't
> work with that group so I don't know anything about timeframes.

Is there a way to get in touch with that group? As you may know we have
a pretty stable and reliable version of a driver for your older PS/2
products (thanks to Synaptics releasing very detailed interfacing guide)
which is integrated in both kernel and Xorg, and which is used by most
distributions. Users also expect "synaptics" to just work with their
touchpads. I would rather see patches extending the exsting driver
instead of completely new piece of software.

> I also
> don't know if it will be made open source or as a proprietary binary -
> or both. But we are definitely planning on supporting our PS/2
> touchpads on Linux.
>
> I will check into the Interfacing Guide and get back to you. The
> latest is on our web site
> (http://www.synaptics.com/developers/manuals) but it doesn't have info
> about multitouch in it. If there is a newer one I'll let you know.
>

Thank you, much appreciated.

--
Dmitry
