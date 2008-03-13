Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYCMMXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYCMMXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYCMMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:23:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39625 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYCMMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=acR62VVmxr4fNd0sLViQZ2FwO8SP0x++eyVF7+ikyiLeGh0DtuyBONKgyDZPUnfOhJDHi+WCgDMteUl1B5+CbFbwacw/sICan26U3SXSj9gGf2dPIv26Ew8iEp6zxGJ9KR3gMyeCO0/s7SkwmkPDQWMeltJmEubLm4OwDdfQK3E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [BUG] PLEXTOR DVDR PX-740A drive not ready for command
Date: Thu, 13 Mar 2008 13:37:16 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>
References: <47D8F73F.4090501@gmail.com>
In-Reply-To: <47D8F73F.4090501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131337.17095.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 13 March 2008, Richard Genoud wrote:
> Hi!
> On ubuntu bug tracker, there's some bug reports about DVD drives that don't respond anymore.
> 
> The affected drives are:
> PLEXTOR DVDR PX-740A
> BENQ DVD DD DW1620
> PHILIPS DVDR14P
> SS-SAMSUNG SCR-3232
> Matsushita SR-8584-B
> (for now)
> 
> the error message is :
> hda: status error: error=0x00 { }
> ide: failed opcode was: unknown
> hda: drive not ready for command
> hda: status error: status 0x59 { DriveReady SeekComplete DataRequest Error }

Could we get full dmesg for this particular system/problem?

Please also;
- test 2.6.25-rc5 on _your_ system
- verify that configuration of hda and hdb devices is correct
  (master/slave settings)

> more details on the ubuntu bug-tracker:
> https://bugs.launchpad.net/bugs/179336
> https://bugs.launchpad.net/bugs/182996
> https://bugs.launchpad.net/bugs/181561

There is far too much information there (different error messages,
different host drivers, some systems are using libata...) - please
open a new bug entry at http://bugzilla.kernel.org so we can start
"clean" and fully concentrate on fixing this bug.

PS Thanks for bisecting it.

Bart
