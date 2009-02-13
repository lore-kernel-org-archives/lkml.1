Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbZBMOex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbZBMOex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZBMOen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:34:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:16915 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZBMOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=TTDEoMl6CkM5bvYldHrDpHsj6R1+DYh/dV2RjeIcD7un+A1QI6aWSigmzyA1k3Lwnn
         fBlnq3OybTA8ip9eOMMLI60Xnq4j+ytKKhQDx7DhM2N0WAWB1temSUpHHrYpUEPdapnl
         L/Q0l99tDdc/tc0gLWfBFFFP+/R9yGzXAN4wU=
Message-ID: <499584FC.2050104@gmail.com>
Date: Fri, 13 Feb 2009 08:34:36 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
References: <200902131428.40212.hanno@hboeck.de>
In-Reply-To: <200902131428.40212.hanno@hboeck.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ccing linux-ide)

Hanno Böck wrote:
> I was about to shred some old hard drives. On one Hard drive, identified as:
> Conner Peripherals 240MB - CP30254
> 
> it was detected as 1.1 TB (!) and obviously throwing lots of errors after 
> getting over 240 MB.
> 
> Is this issue worth investigating further? System is ubuntu 8.10. If anyone 
> wants to have a deeper look, I can obviously donate that harddrive if you pay 
> me shipping costs.

That would be worth investigating, yes.. If you can provide the dmesg 
output from bootup, as well as the output of hdparm --Istdout on the 
disk device, that would be useful..
