Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZGOSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZGOSA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZGOSA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:00:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:61463 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZGOSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VIEgvucWe2tnH0XdDHTqURMISyMErd/QTIt29dFJ5hUdtOjDOFOIRUeULvR8pwxkUU
         fBPTgsf/XQt1jxp4HeiGlf5Zd44jtwfvzjc8xRCLreAI7D7h/8nGWBhZPvKBgO6xRSwd
         fcuVLI5ZgsJTF5b3NgBoYhj6GbwM62fgpQaH4=
MIME-Version: 1.0
In-Reply-To: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com> 
	<20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Jul 2009 11:00:07 -0700
Message-ID: <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
Subject: Re: Generic events for wake up from S1-S4
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 8:51 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Tue, Jul 14, 2009 at 4:53 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> On Tue 2009-07-14 15:11:45, Luis R. Rodriguez wrote:
>>> I'm working on Wake-on-Wireless support for wireless right now [1].
>>> Upon wake up I wanted to inform the kernel of the event which caused
>>> the wake up but am not clear if there is a generic API for this. Mind
>>> you, for WoW we'll need at least some AC power to the card so we'll
>>> need to at least be in S3-Hot so we'll only need events for that for
>>> now.
>>>
>>> Do we have some generic infrastructure to gather reasons for wake up
>>> from S1-S4 and pass this to userspace yet?
>>
>> I do not think generic api exists...

Going back to this topic -- any suggestions? Will a generic netlink
family be OK? Or perhaps easier a udev event for some suitable
existing parent ?

  Luis
