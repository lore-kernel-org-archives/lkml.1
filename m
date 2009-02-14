Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZBNRke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZBNRke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 12:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZBNRk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 12:40:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:51733 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZBNRkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 12:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jhcH0nDfT9qGlHFQbkfWFZr/aY2Idrioyi6zA6O9Q3m7Pocdaj7/RLBUX0cVCRZ+ii
         g1TkOPPpp0NDQnFlalEhCV9+YvsWbhqGpus1v+f5zMPKeFaavcdofehdeg8e+7jAstib
         1YEfgy/rQIAjz8Bo8XrganzRHRCMPSmf/n/3w=
MIME-Version: 1.0
In-Reply-To: <6bd94bae0902130829r15e6eacag25220487457027ad@mail.gmail.com>
References: <6bd94bae0902130829r15e6eacag25220487457027ad@mail.gmail.com>
Date: Sat, 14 Feb 2009 09:40:23 -0800
Message-ID: <2c0942db0902140940v4b16c517mcbcd4874466e5158@mail.gmail.com>
Subject: Re: contact problem? (was Re: Spurious Filesystem corruption with 
	ext3 + large (<400GB) hw RAID ...)
From: Ray Lee <madrabbit@gmail.com>
To: Manfred Wassmann <tux.wassmann@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 8:29 AM, Manfred Wassmann
<tux.wassmann@googlemail.com> wrote:
> On Fri, Feb 6, 2009 at 7:50 PM, Ray Lee <ray-lk@madrabbit.org> wrote:
>
>> Huh. It may be related to whatever kernel version Ubuntu uses to boot
>> up the install media. Try a different version of Ubuntu (older, newer
>> if a newer one exists) to see if it has the same problem.
>
> Thank you for your notice but as I mentioned the problem occurred
> first with my custom built kernel and the Ubuntu installation disk was
> used only to reproduce the error -- Ubuntu is not what I use anyhow,
> I'm on Debian since I switched from Slackware in 1995 ;-)
>
> But now it looks like we had an exotic hardware problem here. Just
> before the weekend the RAID controller reported a degraded array and
> switched to the hotspare disk. On Monday the original array was
> recreated and everything worked fine until Tuesday morning when the
> array again was degraded. But then since the disk was checked and
> reinserted into the array all problems are gone :-\
>
> Is it possible that such a problem is caused by bad contact within the
> drive bay connector?
>
> The reason why it occurred with ext3 only might then be that ext3
> stores it's backup superblocks at addresses which are otherwise unused
> by a largely empty filesystem.

(Ah, I missed this message first time around. Please always do a
reply-to-all for lkml.)

Bad contacts, sure, or (more likely) a marginal power supply? Can you
try a different enclosure, or a different power supply for the
enclosure?
