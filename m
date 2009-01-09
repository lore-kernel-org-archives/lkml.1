Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZAIVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZAIVUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZAIVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:20:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43674 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZAIVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:20:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4967BF99.7010507@s5r6.in-berlin.de>
Date: Fri, 09 Jan 2009 22:20:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and	may
 fail without recovery strategy
References: <496798FE.8030900@s5r6.in-berlin.de> <20090109205633.GB19904@suse.de> <4967BE13.6070003@s5r6.in-berlin.de>
In-Reply-To: <4967BE13.6070003@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Greg KH wrote:
>> I originally looked at changing this to be at device_add time, but I
>> think there are some code paths that do device_initialize and then do
>> some operations on the device before calling device_add.
> 
> get_device() and put_device() seem to be about the only things that are
> interesting before device_add().
> 
> Don't know if a final put_device() in this situation

...would require dev->p to be present.
-- 
Stefan Richter
-=====-==--= ---= -=--=
http://arcgraph.de/sr/
