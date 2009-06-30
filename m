Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZF3F5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZF3F5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZF3F50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:57:26 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:59356 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZF3F5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cA7gGy+QrvjQtWjD0Jl4/WNo1Tza+gM5k1uSFj/GQYu54iM0QBGdgalvg8TcmedZ0x
         kEigO8PR7r1T9ZTV9V2oUfznDVMdveghJJNdEW2nn7s6ZwaZczCVnLOxaor07lYWCAMN
         apidX3K9ywkf8jQEMxH0w7akY0ogOtRc+Tx3I=
MIME-Version: 1.0
In-Reply-To: <20090630022150.GY20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net>
	 <20090628223258.GP20436@tamriel.snowman.net>
	 <20090630011541.GL22480@ldl.fc.hp.com>
	 <20090630011709.GT20436@tamriel.snowman.net>
	 <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com>
	 <20090630015140.GV20436@tamriel.snowman.net>
	 <20090630015302.GN22480@ldl.fc.hp.com>
	 <20090630021013.GX20436@tamriel.snowman.net>
	 <20090630021517.GA3683@lackof.org>
	 <20090630022150.GY20436@tamriel.snowman.net>
Date: Mon, 29 Jun 2009 22:57:27 -0700
Message-ID: <86802c440906292257q618a5953s683997bb309156b0@mail.gmail.com>
Subject: Re: ACPI issues on HP DL585 G2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: dann frazier <dannf@hp.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 7:21 PM, Stephen Frost<sfrost@snowman.net> wrote:
> * dann frazier (dannf@hp.com) wrote:
>> On Mon, Jun 29, 2009 at 10:10:13PM -0400, Stephen Frost wrote:
>> > On the other hand, my coworker tells me that he tried swapping in a P800
>> > on this DL585 and it didn't solve the problem at the time.  Specifics
>> > are a bit difficult (this was last year sometime).
>>
>> Ok - though my question was to understand what is different between
>> this DL585 and the other DL585s you have that are working.
>
> Well, I've got 4 DL585 G2's:
>
> durin - running 2.6.22 w/ P800 fine (had problems w/ 2.6.26)
> stormcrow - running 2.6.22 w/ P800 fine (had problems w/ 2.6.26)
> aragorn - running 2.6.29 w/ P800 fine
> vardamir - running 2.6.30 w/ P600 (needs noacpi to boot)
>
> vardamir used to have a QLogic Fibrechannel card in it as well, but I
> pulled that over the weekend to see if that was causing the problem.
> Didn't change anything though.
>
> I don't think there's anything else all that special about these
> systems.  aragorn's got 64G, the other 3 have 16G, I think they've all
> got a full complement of SAS drives, etc.

can you make sure the P800 or P600 are in same pci-x slot?

YH
