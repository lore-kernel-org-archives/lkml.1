Return-Path: <linux-kernel-owner+w=401wt.eu-S1161453AbXBGWVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161453AbXBGWVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161273AbXBGWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:21:53 -0500
Received: from web52902.mail.yahoo.com ([206.190.49.12]:26233 "HELO
	web52902.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422918AbXBGWVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:21:51 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 17:21:50 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=OXiKTxwYtmOJwT5u/GrEyBKEdCf4uDDkP9qImHZniA/mbaoSXhjjmIiUJX4qR3LDZMtdJxrPGPzsEfqmP4JtjKj4jgRZJHTitYDH177idHsjIIcyarJocfnc2qVwCEFhxnf7cRczo4ozd9sXIscPi77KfSzz4PmfdzCOROS7IT4=;
X-YMail-OSG: Ez009UYVM1mhDqAWIlzvopOqYIcQ.RTwX4WZA5JftPQSXz8pp_mkr6vrYvbw6.k4Acwl5isa6..fvm5jgAiXO9VJnNgjPRW5lroaKpv2J0yGcrcYonSYIBmoPJKKREr19_uqqmVyXU752kFZnAiNPsDlng--
Date: Wed, 7 Feb 2007 14:15:08 -0800 (PST)
From: Simon White <sidplay2@yahoo.com>
Subject: Multiple virtual bus instances
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <883291.79449.qm@web52902.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been working through trying to create a virtual
bus.  I've
successfuly made it work for a single instance but
wanted to
confirm how to create multiple instances of the
virtual bus.  I
believe to do this you have only one instance of your
new
bus_type registered but register multiple instances of
struct
device for it.  I just wanted to confirm that was
correct.

Lastly how do you walk over all devices on a bus
instance?  I
note bus_for_each_dev but that appears to take a
bus_type
rather than struct device instance, hence I assume it
will return
all devices from all instances.  I know I could
compare each
device to see if it is on a certain bus instance but
wondered if
there was a better way?

Regards,
Simon


 
____________________________________________________________________________________
Don't get soaked.  Take a quick peak at the forecast
with the Yahoo! Search weather shortcut.
http://tools.search.yahoo.com/shortcuts/#loc_weather
