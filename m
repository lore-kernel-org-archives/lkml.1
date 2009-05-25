Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZEYIwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZEYIwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEYIws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:52:48 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:52025 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZEYIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JIsfGSNrwNOR/bzrpxEo3rvLkPUpp9BEq9DdgSqStIgFF1wIzrf2Vz6FN8kE/M8tPK
         r92MAREGlLEBdu40KryoK0BwKY6j/+2LUJ5t2nyfqlrsfwRbK2JvvCfGAHSAmEUp/ydv
         tPm3KmirwTMOrygeBirtzetDh5zhUNKNzifKg=
MIME-Version: 1.0
In-Reply-To: <4A1A538F.2030003@samsung.com>
References: <20090515131636.GE4443@nokia.com> <20090515200235.GA11829@nokia.com> 
	<4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> 
	<20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk> 
	<4A125265.6040509@samsung.com> <4A153E3E.8090509@cam.ac.uk> 
	<4A166083.8080704@samsung.com> <4A16AA1E.9010407@cam.ac.uk> 
	<4A1A538F.2030003@samsung.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Mon, 25 May 2009 09:52:27 +0100
Message-ID: <45cc95260905250152h5fe350b8kbdc2333cfea3c393@mail.gmail.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
To: Kim Kyuwon <q1.kim@samsung.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, felipe.balbi@nokia.com,
       Kim Kyuwon <chammoru@gmail.com>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I haven't read all documents cited here (IIO, ...), but it seems that
there is a big attention made on performance.

Can we think also in the way information can be shown for a device.
To be concrete, I actually work on some multi-touch tablets, and it is
useful to create 2 or more "views" of the device.

A device file that emulate a mouse when only one contact is on the
tablet, and another showing more general information about all
contacts.
The first is used by simple applications, the other by more advanced
ones that can treat complex multi-touch events.

This is only one use case, but like in the databases, maybe simple
user (or predefined config. by other users) can propose other "views"
of a device.

Then maybe we would need a configurator (or text configuration files)
for creating these views.

I am not also very convinced why events matching are "cabled" inside
driver source code.
The matching between information sent by device and system events
(ABS_X, ...) is inside source code and any modification needs
recompilation.
What if someone should switch between 2 different matching ?

---
ikbel
