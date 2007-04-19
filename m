Return-Path: <linux-kernel-owner+w=401wt.eu-S1030812AbXDSE6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812AbXDSE6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 00:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031064AbXDSE6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 00:58:13 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:32901 "EHLO
	asav10.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030812AbXDSE6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 00:58:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPCTJkZKhRO4W2dsb2JhbACQAR0NBhA
From: Dmitry Torokhov <dtor@insightbb.com>
To: johann deneux <johann.deneux@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Date: Thu, 19 Apr 2007 00:58:10 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com> <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
In-Reply-To: <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704190058.11625.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 19 April 2007 00:25, johann deneux wrote:
> On 4/18/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > johann deneux napsal(a):
> > > Jiri,
> > >
> > > Which solution did you chose to implement? From what I remember, we
> > > last discussed Dmitry's idea of specifying an axis for an effect, then
> > > combine several effects to achieve complex effects.
> >
> > I think you mean motor instead of axis, because I don't push real axes to
> > the devices, but motor's torques...
> >
> 
> Yes, sorry, I meant motor.
> 

I have been thinking about this and I don't think that exporting motor
data is a good idea, at least not in case of Phantom driver. The fact
that there are 3 motors is a hardware implementation detail and it
is not interesting for general application.

My understanding that the end result of controlling these 3 motors
is a force vector (I don't know if there is such english term, this
is a literal translation from russian) applied to user's hand.
If we are interested in using FF API we need to come up with a way
to express this effect without exposing implementation details of
one particular device.

-- 
Dmitry
