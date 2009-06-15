Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZFOLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZFOLsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZFOLsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:48:04 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35382 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZFOLsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R4hzbcVPcjAlU8BkHKFQn1Ss1EBg4GKr8KJr9YS1XlddDIKhPl/VHwC1bPLlrmw62D
         5KZXhPvbCgJ6fRg1rUPu5BVDgRC81rTrDJCCVaQlFq/kGUeEQg3NKkYLzU8jUQMsYf3H
         Gqzi+OMV6mJYntdfzAxUEoG0xLdfa/KPunN4o=
MIME-Version: 1.0
In-Reply-To: <71cd59b00906130436i5024afa7q5b7cb40005014e14@mail.gmail.com>
References: <20090612223255.GD14878@aniel.lan>
	 <71cd59b00906122352g77e8afdeh235c2a73b323a0d7@mail.gmail.com>
	 <20090613110627.GG14878@aniel.lan>
	 <71cd59b00906130436i5024afa7q5b7cb40005014e14@mail.gmail.com>
Date: Mon, 15 Jun 2009 13:48:03 +0200
Message-ID: <71cd59b00906150448k64ae335ah597e194180048c46@mail.gmail.com>
Subject: Re: [PATCH 0/2] eeepc-laptop: add 3G rfkill support for 901Go
From: Corentin Chary <corentin.chary@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 1:36 PM, Corentin Chary<corentin.chary@gmail.com> wrote:
> On Sat, Jun 13, 2009 at 1:06 PM, Janne Grunau<j@jannau.net> wrote:
>> On Sat, Jun 13, 2009 at 08:52:17AM +0200, Corentin Chary wrote:
>>> First,
>>> Could you fill http://dev.iksaif.net/projects/acpi4asus/wiki/CMSG with
>>> your model CMSG ?
>>
>> done, I suspect there's an error for the 701 and 901 in that table.
>> CM_ASL_CARDREADER should be 1 instead of CM_ASL_MODEM.
>> http://wiki.debian.org/DebianEeePC/Models supports that.
>
> I'll check that, thanks
>
>> Do you plan to update eeepc-laptop with all CM_ASL bits?
>
> All CM_ASL bits found in latest asus_acpi driver, yep.
>
>>> Then, I was working on a patch to refactor rfkill code in
>>> eeepc-laptop. With this patch, adding 3g rfkill
>>> is only 15-20 lines.
>>
>> good, I was too lazy to refactor it.
>>
>>> I'll add it to acpi4asus git tree soon.
>>> From here:
>>>  - I can rework your patch
>>> - you can re-send it when rfkill refactoring is here.
>>>
>>> as you want =).
>>
>> Drop me a mail when you're done but doesn't really matter who does it.

You can find the patch here,
http://git.iksaif.net/?p=acpi4asus.git;a=shortlog;h=refs/heads/eeepc-laptop



-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
