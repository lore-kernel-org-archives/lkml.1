Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbXINGi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbXINGi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 02:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXINGiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 02:38:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62928 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbXINGiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 02:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L2t/iDpARhef6IjC9C+Kaf3edPcAg1FXVeO/cDkE59AGWYcmtLNDgbPeRzN0JYTTdiy6mekdAGl1/d1Xxd3Ek+XdAsrxJ/CZYgj1xnLkygUBqcuE/TouefmySbhrYeq6fqEUTwsxzlpzUrLiGMP8eKF0m5T2+3OqsommXCAuCic=
Message-ID: <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
Date: Fri, 14 Sep 2007 08:38:14 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steven Toth" <stoth@hauppauge.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <46E9DDC7.4000403@hauppauge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Steven Toth <stoth@hauppauge.com> wrote:
> Markus Rechberger wrote:
> > On 9/13/07, Steven Toth <stoth@hauppauge.com> wrote:
> >
> >>>> Also there is to consider a non technical aspect, whether vendors will
> >>>> misuse this interface for binary only, undermining the efforts put in
> >>>> for OSS drivers.
> >>>>
> >>>>
> >>>>
> >>> What holds companies for using the current available code putting it
> >>> into an rpm or deb package and releasing such code now?
> >>>
> >>> The Avermedia example I pointed out to is a good example already.
> >>> As from my side I won't release binary drivers.
> >>> Although on the other side:
> >>> * are drivers from vendors which work through several kernel versions
> >>> that bad?
> >>> * Why did someone duallicense videodev2 with BSD/GPL?
> >>>
> >>> I would appreciate if someone else on the list could also comment
> >>> the reason that drivers should all be included in the linuxkernel just
> >>> because forcing the companies to release binary drivers because
> >>> of that. My opinion about that is if a company wants to go opensource
> >>> they will do so, if not they will either not release a driver or release
> >>> nothing.
> >>>
> >>>
> >>>
> >> I know for certain that adding a userland API tuner/demod interface to
> >> the kernel, allowing non-caring opportunistic silicon or board vendors
> >> to developer closed source proprietary drivers, will have a negative
> >> effect on the community and we'd set back linuxtv 3-5 years.
> >>
> >> I know for certain that it would happen. Trust me.
> >>
> >> I've told you this countless times and you're not hearing me.
> >>
> >> Hauppauge have some leverage with Conexant and NXP to release public
> >> datasheets. If they just have to release a demod.so (or similar)
> >> loadable, they'll defer to the board vendors and we'll see the certain
> >> board vendors 'locking other board vendors' out of their drivers. We'll
> >> see embedded firmware, not shared between drivers.
> >>
> >> Except, it won't stop at demod.so. It will extend into unfixable bugs
> >> for VendorB's board, because VendorA doesn't want to release a new
> >> demod.so, and VendorB has no linux resources. What happens next? For
> >> financial reasons - demod.so will begin to include checks to see if
> >> specific PCI or USB devices are present in the system, and will fail to
> >> work properly (if at all) when they're not being used with the preferred
> >> products.
> >>
> >>
> > Steven,
> >
> > what stops vendors of using the current existing code to achieve that
> > goal. They could provide binary drivers with the existing API.
> >
> >
>
> Because the good people in this mailing list are keeping them honest.
> Give any board or silicon company the ability to protect their IP, even
> in the smallest way and they'll do it, and for no good technical reason.
> It's a cut throat market and it's not clear that everyone understands
> just how thin sales margins really are.
>
> That means Hauppauge potentially releasing a binary driver, because it's
> much easier than seeking silicon vendor permission for a public diver.
> The net result of that would mean I'd have to leave the company and find
> another company that practices the one thing I truly care about ....
> open source and open development groups.
>

well you could already release binary drivers if you would be
concerned about it, so again all that seems to be no reason for me.
What stops Hauppauge in implementing drivers another way?
For example the USB drivers completly in userspace.

> I'm keeping Hauppauge honest with their Linux involvement and I'm not
> alone. Other devs in other linux subsystems in other companies are doing
> the same thing.
>

For example the UIO thing, accessing MMIO through userspace, also
accessing usb control messages from userspace. Because of that reason
since it is already possible to provide binary drivers your reason is
again not valid.
The code which the userspace tuners are connected to is GPL so what.
Beside that Hauppauge is not the only company out there although I also
have contacts there at Hauppauge Europe.

> Binary drivers (or binary components) leads Linux back in time.
>
> I can't believe your so passionate about protecting secrets.
>

Please point me to the part where I am passionated about protecting
any of my opensource code which is currently available.
I have other arguments why to put that part into userspace.

> > What stops companies to intercept the ioctl calls and overriding some
> > I2C commands?
> >
> >
>
> Why would a company want to do that? Companies don't do that, hackers do
> that.
>

just to achieve what you're trying to argue with that companies could
use some odd constructs which could be used to publish their drivers as
binary only. I don't see the problem there if they want to do so.

> > Since you know about windows drivers (at least I think that you know
> > about it) you might know about the limitations of the v4l/dvb API
> > in general the reason just put as much code as possible into the
> > kernel just for forcing companies to release code under GPL doesn't
> > seem to be valid.
> >
>
> It seems perfectly valid to me.
>
> > How about proprietary video formats, would you also place the decoding
> > algorithms in kernel  just to force companies to release their code
> > for it?
> >
>
> The kernel has no good API for those, each new type of video device and
> suggested API is judged on it's own merits and discussed on the mailing
> lists.
>

my experience is that there's no way of discussing things properly
with some guys there. Hey if someone wants to get his device work
somehow he's invited to join the whole project, what happened with
that project during the last 2 years (and probably before already)
does not seem to be an open community to anything.

> > What do you think about the existing usbfs implementation, which
> > allows to implement usb drivers completly in userspace?
> >
>
> Those are not my problem and I don't use them, you should raise that
> with the relevant usb-dev mailing lists. I'm here because I care about
> linuxtv. Please stay on topic.
>

I'm not sure if you are aware of that userspace usb video driver which got
published on the video4linux mailinglist. It hijacked ioctl calls and used usbfs
for having the whole driver in userspace.
I would like you to have a look at:
http://www.harmwal.nl/pccam880/

"This is a user space video4linux driver for the PC-CAM 880 and other
Zoran/Coach based USB webcams"

> > What do you think about IOMMU?
> >
> >
> Just because AMD or INTEL want to invent some whizzy new technology it
> doesn't say anything about the TV card development and retail business.
> Intel and AMD have teams of Linux engineers helping operating system
> developers bring their ideas and technologies to new platforms. That's a
> million miles away from any of the TV board vendors I know of, who have
> little or NO fulltime linux developers and consider the < 5% market
> fringe at best.
>

it helps to virtualize devices and introduces newer features for that.
Some interesting projects could be derrived out of that, there are
quite a few interesting papers floating around how drivers could be
handled in future.

> Markus, senior devs in the LinuxTV group are telling you, based on their
> commercial experience, that userspace access is technically great, but
> long term it will be used against the community and will ultimately hurt
> linuxtv development.
>

I've seriously seen where senior devs lead other people during the last year,
repeatly pointing to wrong solutions and finally redoing things a completly
other way. Protecting their own interests and not seriously looking to get
more people on board for fixing up those API issues.

> If you want to reply and have the last word, go ahead, but repeating
> what I've said on this list in the past - I'll never support the
> userland tuning/demod idea.
>
> I wanted to work directly with you on the em28xx tree, helping you
> remove the 5% of code that Johannes referred to, but you said no. I
> wanted to help you make the tree conform to the linuxtv standards for
> frameworks, you said no.
>
> If you care about LinuxTV you'll work with the core subsystem developers
> to bring your em28xx tree inline. If you don't care then why are you here?

It doesn't really work out to work with those 3-5 "core" people who are active
there.
It starts at the point where RFCs are submitted and not answered,
discussions are avoided and finally some people start to complain.
In case of pointing people to wrong or bad solutions, one "Maintainer"
pointed out it would be like manipulating others work ... this exactly
happened with the em28xx project. It's not only about the current
implementation, as from my side I also take upcoming products into
account and how long it would take to get something which isn't
supported by the API fixed.. it's just something that is too hard and
I don't want to debate about things where I know that the outcome
is that I have to wait till someone of those 3-5 "core" people come up
with an own idea.
This is my impression of the overall situation you might
try to change it during the next few months but in case of further
implementations I will for sure try to get around that situation because
in history I only received nontechnical arguments why my stuff wasn't
accepted (again this starts at the RFCs).

If you want to comment this, please take all parts of that response into
account, especially the userspace v4l driver which I pointed to.

Markus
