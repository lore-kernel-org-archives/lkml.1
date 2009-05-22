Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZEVSsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZEVSsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZEVSsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:48:25 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:54225 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZEVSsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WWOiFG1NvK3sXugReYYIWEMPWhH+8PvJRjDl3CHHPEfVqpPvY30VHlH/6oRUQzlC6O
         nqqL6vbpm3PkKgD9RuEt1s/rA1Q7HuE8ut5xwzxTSiBfhMQMPhpg9j3Jlov2TqUgD+1b
         onCFBOdRQ1dmvkr47LpWfgbEDbw18Fg3r4MbI=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905221124y412dc3bdp65ad1b74373175a9@mail.gmail.com>
References: <ac3eb2510905220821n629314c3tb113802f52abc67c@mail.gmail.com>
	 <Pine.LNX.4.44L0.0905221149030.3006-100000@iolanthe.rowland.org>
	 <ac3eb2510905221124y412dc3bdp65ad1b74373175a9@mail.gmail.com>
Date: Fri, 22 May 2009 21:48:25 +0300
Message-ID: <1295ed070905221148k78c443d6m3a270dd57c948da@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
From: Pantelis Koukousoulas <pktoss@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The idea is that there will be one lock file per port.  So for example,
>> a hub device with four ports might contain inside its sysfs device
>> directory: ports/1, ..., ports/4.
>
> Sounds both good to me.

Yes, I 'm happy with that solution too.

Thanks,
Pantelis
