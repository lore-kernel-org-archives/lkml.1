Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbXIKOGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbXIKOGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbXIKOGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:06:13 -0400
Received: from main.gmane.org ([80.91.229.2]:59712 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbXIKOGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:06:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: udev: Inconsistency between %b and %p?
Date: Tue, 11 Sep 2007 16:11:36 +0200
Message-ID: <fc67c1$vci$1@sea.gmane.org>
References: <fbp6a3$k6r$1@sea.gmane.org> <jeodgfu6pz.fsf@sykes.suse.de>	 <fbppo0$rli$1@sea.gmane.org> <3ae72650709061803u7ed2ff21v511f219e742ecd7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c3ea.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
In-Reply-To: <3ae72650709061803u7ed2ff21v511f219e742ecd7a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>>>> ATTRS{idVendor}=="0dda", ATTRS{idProduct}=="2005", SUBSYSTEM=="scsi",
>>>> ACTION=="add", PROGRAM+="/usr/bin/test.sh %b %p"

> It's fine. $id, like some other values too, is a value of the device
> where all keys successful matched while walking up the chain of
> devices.

But the "SUBSYSTEM" didn't match for the USB-device.

I still don't know, what %b contains and in which situation the value in 
%b may help anyone.

> Seems you are looking for the name of the device you received the
> event for, so just use $kernel instead.

Yes, this did the job. Thanks for the hint.

CU

Manuel

