Return-Path: <linux-kernel-owner+w=401wt.eu-S1752333AbZGIES5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbZGIES5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZGIESs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:18:48 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64897 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZGIESr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EdUGauVVekfQC0/zW5ud1ah6BaNrqvRhPPN1wmZNhMi+CPgjW0POV09DZXVsr/oZn7
         QPqIG93eLxtuiJ1qjksh/bmzalbRg77czFH+GxckeSWxGMaff0BH7z0c5HuK8FUD4b++
         ThbRiaRbDOJdaqYTdqSG/Aali/4u0iAKqkKCE=
MIME-Version: 1.0
In-Reply-To: <4A551B43.3020104@gmail.com>
References: <4A54FB81.30302@gmail.com>
	 <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
	 <4A551B43.3020104@gmail.com>
Date: Thu, 9 Jul 2009 05:18:45 +0100
Message-ID: <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 11:18 PM, Marcin Slusarz<marcin.slusarz@gmail.com> wrote:
> Hin-Tak Leung wrote:
>> Is there a v1, and what does it use?
>
> I don't know.

2009/7/8 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Wed, Jul 8, 2009 at 11:49 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>> Is there a v1, and what does it use?
>
> I have the v1, it is rt73-based. (v3 is rt2070, not rt3070, though.)

I guess I have two questions: (1) are the 3 variants labelled in that
way as such v1/v2/v3 (on the box,
or one of the USB device identity queries)? (2) are they distinguished
by different product IDs?

The point is that the commit (which only changes the help message) is
only appropriate if they are labelled as v1/v2/v3 and not
distinguished by different product IDs. If they are distinguished by
different product IDs and the current codes for the three drivers bind
correctly to each, then the change is only relevant to people who
manually build their kernel and want to build one driver but not the
others. (i.e. instead of distros which ship the full set of driver
modules). Which goes to my first question...

if they are not labelled v1/v2/v3 as such, it may be more
useful/informative to change to

    [some variant of ] ... [(other variants are supported by the
rt2070/rt3070 modules)]

instead of just adding [v2] to the end.
