Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbZLJKp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbZLJKp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbZLJKpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:45:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:32650 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751AbZLJKpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:45:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dedPZsCb3QEw8QQ+Jcx2RrgY9otaHgh81lMCvc3u62fDuu/RJQPRiKEVyylriO89ND
         QGKIsZ1lKKR94yuq+N2PYthrAumYRZnJ+ArSA6FZ6eqMKglP8otLKGGvTB6wgCDxR0Xe
         xcJ5B+gZUUldb+A87GXcYP8ggiUMIPgrAbqqc=
MIME-Version: 1.0
In-Reply-To: <20091210100935.GB2446@ucw.cz>
References: <1260257169-7227-1-git-send-email-ike.pan@canonical.com>
	 <20091210100935.GB2446@ucw.cz>
Date: Thu, 10 Dec 2009 11:38:00 +0100
Message-ID: <71cd59b00912100238l7fe78abcrd07328c15b65971d@mail.gmail.com>
Subject: Re: [PATCH] asus-laptop: add Lenovo SL LenovoCare LED support
From: Corentin Chary <corentin.chary@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 11:09 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-12-08 15:26:09, Ike Panhc wrote:
>> From: Ike Panhc <ikepanhc@canonical.com>
>>
>> This patch is to enable the LenovoCare LED support on Lenovo SL laptop. Based
>> on the found of the control interface by Alexandre Rostovtsev
>>
>> Turn on the LenovoCare LED:
>>  (As root privileges) echo 1 > /sys/class/leds/asus\:\:LenovoCare/brightness
>> Trun off the LenovoCare LED:
>>  (As root privileges) echo 0 > /sys/class/leds/asus\:\:LenovoCare/brightness
>>
>> The patch against current checkout of acpi4asus is below.
>
> Is the driver severely misnamed by now? I believe Lenovo and ASUS are
> pretty different firms...
>

Lenovo ship DSDT with similar ATKD interace.
See http://git.iksaif.net/?p=acpi4asus.git;a=commitdiff;h=31a38147625c283b58137db45e7507cd1e49aa05


-- 
Corentin Chary
http://xf.iksaif.net
