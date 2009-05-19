Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZESKms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZESKms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZESKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:42:41 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64451 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZESKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:42:41 -0400
Date: Tue, 19 May 2009 13:42:02 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Kim Kyuwon <q1.kim@samsung.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       ext Kim Kyuwon <chammoru@gmail.com>,
       ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
Message-ID: <20090519104202.GB30597@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> <20090515200235.GA11829@nokia.com> <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> <20090518091236.GH4443@nokia.com> <4A121C54.2040205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A121C54.2040205@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 19 May 2009 10:42:21.0422 (UTC) FILETIME=[7D2308E0:01C9D86E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 19, 2009 at 04:41:24AM +0200, ext Kim Kyuwon wrote:
> > what if you wanna use the accelerometer as joystick for gaming ? Imagine
> > a portable device...
> 
> So I said that accelerometer driver can use input_register_device, 
> input_register_polled_device functions.

exactly...

> Good point. We should consider the extensibility. I agree a sensor 
> framework that abstracts input_dev. However we should discuss with Jean 
> Delvare about the boundary between lm-sensors and input(?)-sensors
> 
> * However we should first confirm and review that Jonathan's iio can be 
> the solution for input(?)-sensors *

sure, makes sense to me

>  > But then comes another question: what to do with
> > magnetometers, gyroscopes, etc etc ??
> 
> If we make a extensible sensor driver, I think we can add these new etc 
> sensors in the future. step by step.

agreed here. But we have to think that this might get extended, so we
should start thinking of an abstraction layer that could evolve for
magnetometers, gyroscopes and other sensors

-- 
balbi
