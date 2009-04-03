Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZDCAyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZDCAyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZDCAyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:54:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:44526 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZDCAyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T1vnWGFPUR/7viqh0SGHYrY39yDoh2RSwYNRT89526Aq3Wd+xMRpZDc9M/laBh/ukC
         Nkc93YH7eXSaCvbaxaww9gVzKbq3201jgMvLF7CJ6O7ECFoT4fiXLIhJBLba+/HGmwoO
         ZG54XZjkcPvDTxo4Z/NqXbrtrodIadWWx6IIA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0904021731060.6162@bogon.housecafe.de>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <alpine.DEB.2.01.0904021731060.6162@bogon.housecafe.de>
Date: Thu, 2 Apr 2009 18:54:14 -0600
Message-ID: <9b1675090904021754v3bcbb8cemd746c0d5f24362a4@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 6:38 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Thu, 2 Apr 2009, Trenton D. Adams wrote:
>> Oh, I should have clarified.  It improves performance under heavy
>> load.  Under normal load, mounting without sync is fine.  What I tend
>> to do is mount with "remount,rw,sync" when heavy load is starting.
>
> Really? How does mounting with "-o sync" *improve* performance? I am
> certainly aware that mounting with "-o sync" has severe performance
> impacts, but was proposing it anyway *only* to tackle the data integrity
> problem. However, I'm curious if usescaes in the embedded world are
> equally affected by this.
>

Oh, well for my system, if I do heavy IO, my *fsync* performance drops
like a rock.  fsync on even 1M takes 15-20 seconds at times.  I have
even seen 50 seconds.  If I mount with sync option, the fsyncs of 1M
take only a couple hundred milliseconds, while the other heavy IO is
happening.
