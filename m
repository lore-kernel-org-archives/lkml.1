Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbXIKIPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbXIKIPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbXIKIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:15:29 -0400
Received: from zone4.gcu.info ([217.195.17.234]:62819 "EHLO
	zone4.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939AbXIKIP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:15:27 -0400
X-Greylist: delayed 1889 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 04:15:26 EDT
Date: Tue, 11 Sep 2007 09:43:34 +0200 (CEST)
To: hmh@hmh.eng.br
Subject: Re: Platform device id
X-IlohaMail-Blah: khali@localhost
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <C5k470vB.1189496614.5481670.khali@localhost>
In-Reply-To: <20070910225205.GB1408@khazad-dum.debian.net>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "David Brownell" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Henrique,

On 9/10/2007, "Henrique de Moraes Holschuh" <hmh@hmh.eng.br> wrote:
>On Sat, 08 Sep 2007, Jean Delvare wrote:
>> * Detection could be moved to user-space entirely, then we would only
>> need a way to instantiate these specific devices from user-space. This
>> exists in other areas (scsi, network) for quite some times already so
>> it shouldn't be too difficult.
>
>Don't like that one, sorry.  Detection often needs the kind of access to
>hardware that is better off contained in the kernel.

Yes, good point.

>(...)
>I will see what I can do about breaking it up in various modules.  But this
>can be unoptimal. If I took it too seriously, thinkpad-acpi would break into
>at least five different modules, if not more, and at least one or two
>modules would need to be there for the common code.  There has to be a
>middle ground somewhere, I think.

I don't know your code and I don't really have the time to look at it
in depth, but I'm a bit surprised. Presumably your driver is
implementing a number of interfaces (e.g. hwmon) and you create a class
device for each one. You can have as many class devices hanging of a
(physical) device, so I fail to see why you would need to register
several (physical) devices.

--
Jean Delvare
