Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYHaD54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYHaD54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 23:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYHaD5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 23:57:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:44799 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYHaD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 23:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WxP1lqJCe4yZa+pvYrZnywhH+l/M5kxkWp0R0sjhAvY6chUc0PUohM3QD5gMPmWd7k
         gWvyR8UBO2bkg8gdCsb0m94d16GQqbq0/dC+m/hd3y35j1eq86H78Bhoi6oHz5Uxes6n
         agLfRSKJRkyrTVdbbYMWP1ZjIgPfjKveJjuC4=
Message-ID: <d9def9db0808302057u25e7ce5yfb2967c893255df0@mail.gmail.com>
Date: Sun, 31 Aug 2008 05:57:46 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
Cc: "Charles Price" <cpwp@w3z.co.uk>, linux-dvb@linuxtv.org,
       mrechberger@sundtek.com
In-Reply-To: <48B98B89.80803@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B8400A.9030409@linuxtv.org> <48B98914.1020800@w3z.co.uk>
	 <48B98B89.80803@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 8:03 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Charles Price wrote:
>>> If you also feel frustrated by the multiproto situation and agree in
>>> principle with this new approach, and the overall direction of the API
>>> changes, then we welcome you and ask you to help us.
>>>
>>
>> I wholeheartedly agree.
>>
>> Although I can't offer any programming input, I do have a variety of DVB
>> hardware and different architectures on which I can test your creations.
>>
>> Happy to help.
>

not reading the parts above, but saying this is Steven, not caring
about the main people who work on something.

There's a split between a few people here (including myself) and other
people from that scene who just don't care about anything.

Manu and the others put in alot work, why screw what he wrote (code)
he has been on vacation (I know he married a few weeks ago - since I
got the invitation) Hauppauge people (Michael Krufky and Steven Toth)
are running their personal own game .. sorry to say that but it's that
way.

I have logs and mails here where Steven and Mike wrote hey that would
be a cool idea about compatibility but when "I" mentioned it again and
spent work on it it was like hey we're linux only (I don't only care
about linux since I also work alot with commercial companies in that
area look at the dibcom website - Job requirement 'independent' code
neither do I want to depend on Windows nor Linux but having something
that works on both in case of hardware is fine - especially I2C is
trivial to realize for everything).

Rethink your position and try to get people onboard but don't try to
screw people and run your own game.

Seeing the comments Acked-By: xyz - I cannot review neither contribute
code but I can provide webspace .. hilarious. get down on earth again
Steven, Mike expecially Mauro - try to get Manufacturers onboard
instead working against you.
I talked alot with Manu he has good connections and is avoing to work
together just as I am because of certain Monopoly and copyright
infringements which you are building here (I see Mauro using leaked
code here!) . Mauro is spreading foo, Manu has the specs for xyz. I
fully understand Manu's point since Mauro did the same with me,
however .. I better don't comment it.

Let's put another thing in here: Greg Kroah Hartman Linux Guy reverted
my patch in favour of supporting the binary Firmware upload tool of
Dell (I fully support Dell here too) although claiming to be
opensource but still running after someone (please comment this one -
it confused me at 'your' position). It was just like ok let's revert
it but not asking why?!
I'm just getting up with this just because I saw following yesterday:
21:07 < pmp> hmm: request_firmware(&fw, CX24116_DEFAULT_FIRMWARE,
&state->i2c->dev) ?
21:08 < pmp> the &state->i2c->dev looks strange and the kernel is
saying that about it: kobject_add failed
             for i2c-1 with -EEXIST, don't try to re....
21:09 < pmp> other fe-driver have a callback in their config-struct...
21:09 < pmp> I start to believe there is a reason ;)

I better cut it now.

Markus
