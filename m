Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbZJOJsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbZJOJsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbZJOJsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:48:35 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:47804 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZJOJse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=jiiMqQAEfPNPoOJYm2FCB2uyE3Ct7SKr/0K2y27NNnf4FNgplF0xuX0LwMi1jPwsPR
         Ocj5Mt9sOjesBqlTDSLK193c9Ns9tiHel/MFCXAWiqdI6bi4lIDC3b1tarLaU2boGz12
         chFBmoc1VLdG89m58Tl5LoL7iCdk5IuAf9E/Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Thu, 15 Oct 2009 11:47:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00286-gcb0b4be; KDE/4.3.1; x86_64; ; )
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910142210.25080.bzolnier@gmail.com> <14add3d10910142328xffa8e91re7902aa3bd04b52d@mail.gmail.com>
In-Reply-To: <14add3d10910142328xffa8e91re7902aa3bd04b52d@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200910151147.29739.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009 08:28:07 Gertjan van Wingerde wrote:
> On Wed, Oct 14, 2009 at 10:10 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Wednesday 14 October 2009 20:56:17 Ivo van Doorn wrote:
> >> Hi,
> >>
> >> > > On Wed, Oct 14, 2009 at 05:28:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> >> > >
> >> > > > I don't have a have a problem with it personally as long as people accept
> >> > > > the competition..  but instead of working on _their_ projects they go around
> >> > > > screaming at everybody who does not want to spin inside the great process
> >> > > > designed by them..
> >> > >
> >> > > Please whine somewhere else.  You have the freedom to work in
> >> > > drivers/staging all you want.  You do not have the power to force us to
> >> > > like it -- especially in a case where you are diverting attention from
> >> > > the community-maintained drivers instead of cooperating with them.
> >> >
> >> > Cooperating you say.
> >> >
> >> > rtl8187 -- before starting the work on rtl8187se I've pinged the maintainer
> >> > to coordinate the effort and hear his opinion on how to progress..
> >> >
> >> > I've never heard back.
> >> >
> >> > rt2x00 -- I know that people have datasheets for some chipsets but I've
> >> > never heard "How can we help you" etc. thing.
> >>
> >> The rt2x00 members received the specsheets under the condition that we didn't
> >> distribute them further.
> >>
> >> So everybody which requested the datasheets from the rt2x00 project were presented
> >> with a choice:
> >> 1) We provide the email address of the Ralink contact person which can device if you
> >> can get the specsheet or not (possibly under NDA, but this isn't always the case).
> >> 2) Specific questions about the registers can be asked and we give all the information we
> >> know from our work on the rt2x00 project plus additional information from the specsheet.
> >> Seeing that the specsheet doesn't always match reality, you get the better answers with
> >> this option, but some people just hate it when they need to ask other people for stuff.
> >>
> >> > All I've ever heard was _lies_ about current state of affairs or that
> >> > my work is in the way.
> >>
> >> I have encounterd your email address in only 2 rt2x00 related discussions
> >> (yes I have checked my entire email archive). Both cases were regarding
> >> staging vs rt2x00.
> >>
> >> So far I never said rt2800usb or rt2800pci were high quality, I never said they were in a good
> >> shape. On the other hand, I often talked about the problems with the drivers, requesting help
> >> to improve the drivers, etc etc.
> >>
> >> So are you basing this "I am hearing lies" about a random person talking on the street
> >> about rt2x00 which is telling the lie?
> >
> > Maybe I've used a bit too strong wording but the fact is that vendor drivers
> > are useful for providing users with *unsupported* and *temporary* solution
> > until the proper drivers are in place have been questioned a lot in the past,
> > and sorry but it is a fact (it may be hard to swallow but it shouldn't be
> > discussed about).
> >
> > The staging is a new game in town and provides real benefit for end-users
> > to use their hardware early while proper solutions are being worked on (not
> > like most of distributions weren't shipping crap drivers anyway -- now at
> > least we have some control over it).
> >
> > This is extremely important in segments where Linux is still not the leading
> > OS.  We cannot tell users to go hike -- they are our users! Moreover they
> > are quite smart so they will use what works best for their needs anyway,
> > not necessarily what is the easiest for us to maintain in the long-term or
> > work on.
> >
> > Staging also helps companies involved to transform their software offerings
> > in a more smooth way.  Often such transition requires long process and much
> > work on the company side to adapt to our model of doing things so patience
> > is recommended.  (Lets not forget that staging provides also a stick part,
> > drivers are removed from staging if nobody cares about them and even if
> > there are volunteers caring about support for certain hardware the company
> > will still get a bad publicity if it doesn't participate in the process)..
> >
> > So staging is here to stay and it is up to particular maintainers how they
> > are going to it use this "tool" and integrate it into their current mode of
> > operation..
> >
> > I'm sorry if my words were offending to you or other wireless developers.
> > I kind of feel the frustration of people who had put years of effort into
> > providing the proper wireless infrastructure + drivers and are ignored
> > by vendors.  However we have to keep the ball rolling and cannot dismiss
> > valid user complaints or ignore other possibilities of doing things.
> >
> 
> All,
> 
> I don't think this discussion is leading us anywhere.
> I believe everybody agrees with the "staging"/Ralink provided drivers to be good
> to provide end-users a working solution until the rt2x00 driver has
> been completed.
> 
> However, the problem that we have seen (from the rt2x00 project point
> of view) is that
> the Ralink drivers that are in staging are confusing / distraction
> developer attention. We
> have had quite a few occasions where new developers started to work on
> the staging
> drivers, as they thought these were "the way to go".
> 
> I think that can be easily solved by including in the Ralink staging
> drivers a README
> file pointing to the rt2x00 drivers, and a note stating that the
> rt2x00 drivers are the ones
> for long-term Linux support, and that the staging drivers are there
> just to help users making
> their hardware work.

I think that there is already a note stating something like that.

However if you think that something needs to be added or changed then
please just send Greg a patch
