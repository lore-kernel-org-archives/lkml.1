Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZCYFWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZCYFWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbZCYFVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:21:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:63614 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbZCYFVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oe2ynXn7VHLIg/UQ5W2ooRCd2SSYJNFoTl6HVfrDjOJ/kySsW98Ag1oq6JXy4/Eaih
         CJ/qNJM8zjbe8VqgIbKhmBGZu9yqEtmr6UQO52A8f+Xy0XI9Duz/zEz1JdW5c5lUNZb3
         Nl1HQkZvtrdpUdNysZtmlVw6lyUXLYV6OXT60=
MIME-Version: 1.0
In-Reply-To: <20090325025944.GA12447@kamineko.org>
References: <20090321065006.GF3834@kamineko.org>
	 <178fec830903211130x7aa2d266u5f249625c4436fd0@mail.gmail.com>
	 <20090322011517.GA17905@kamineko.org>
	 <20090325025944.GA12447@kamineko.org>
Date: Tue, 24 Mar 2009 22:21:41 -0700
Message-ID: <178fec830903242221l6c07f8a1k8c91be94bc70fc37@mail.gmail.com>
Subject: Re: iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 
	500ms
From: Abhi Kolekar <kolekar.a@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you create a bug at http://www.intellinuxwireless.org/bugzilla/ ?

Thanks
Abhijeet

On Tue, Mar 24, 2009 at 7:59 PM, Mattia Dongili <malattia@linux.it> wrote:
> On Sun, Mar 22, 2009 at 10:15:17AM +0900, Mattia Dongili wrote:
>> On Sat, Mar 21, 2009 at 11:30:29AM -0700, Abhi Kolekar wrote:
>> > On Fri, Mar 20, 2009 at 11:50 PM, Mattia Dongili <malattia@linux.it> wrote:
>> > > Hello,
>> > >
>> > > I get this error consistently with all the recent kernels:
>> > > [  338.476057] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
>> > > [  458.976089] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
>> > > [  598.885036] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
>> > > [  598.885050] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX (0x1C) seq 0x02AC ser 0x0000004E
>> > > [  601.869319] iwl3945: Can't stop Rx DMA.
>> > > then the wifi connection becomes useless and I have to re-associate to
>> > > the AP or sometimes to unload and reload the module to get my connection
>> > > back.
>> > >
>> > > The above is on 2.6.29-rc8 but I get it since 2.6.28 (apologies for not
>
> Actually since 2.6.27.
>
>> > > reporting it earlier).  Both my thinkpad x60s and my vaio sz72b are
>> > > affected.
>> > > Reproducing it is very easy, I just need to download even a small file.
>> > >
>> > > After reading some older bug submissions I rebuilt the driver with debug
>> > > support and loaded it with debug=0x43fff, the log is here:
>> > > http://kamineko.org/kernel/kern.log
>> > > The beginning of the log is 2.6.28 with no debug, then you can see a
>> > > reboot and the module loaded with the debug option on 2.6.29-rc8.
>> > >
>> > > Is this a known problem? Is there any other information I can provide to
>> > > help fixing it?
>
> Anyone?
>
> --
> mattia
> :wq!
>
