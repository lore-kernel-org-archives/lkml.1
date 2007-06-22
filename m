Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbXFVMCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbXFVMCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbXFVMBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:01:55 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:6953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbXFVMBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DekUAtX1VobwMhReTqNK0HKUJG0cxM60s6GxRVD3aFyEtbch3iGX/OX0XbqNMOMUWyOgW4BbXFDw6KNmTxbJea1IFOeht4/y+0O+f1Wb1ypd3Wze7x7UWENsOD3uz0/hgSv8umAQCW0GU07ju4yLwi1tulgf3lq2MTAPmj3lVFg=
Message-ID: <d9def9db0706220501k4a1bf8d2wdf62a9638a41829b@mail.gmail.com>
Date: Fri, 22 Jun 2007 14:01:52 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Natalie Protasevich" <protasnb@gmail.com>
Subject: Re: How to improve the quality of the kernel?
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <32209efe0706171150k37148228i60f5a7ab02d229f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
	 <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>
	 <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de>
	 <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
	 <20070617142950.GW3588@stusta.de> <467560CF.6090100@s5r6.in-berlin.de>
	 <20070617182457.GY3588@stusta.de>
	 <32209efe0706171150k37148228i60f5a7ab02d229f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/07, Natalie Protasevich <protasnb@gmail.com> wrote:
> On 6/17/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Sun, Jun 17, 2007 at 06:26:55PM +0200, Stefan Richter wrote:
> > > Adrian Bunk wrote:
> > > >>> And we should be aware that reverting is only a workaround for the
> real
> > > >>> problem which lies in our bug handling.
> > > >> ...
> > > >
> > > > And this is something I want to emphasize again.
> > > >
> > > > How can we make any progress with the real problem and not only the
> > > > symptoms?
> > > ...
> > >
> > > Perhaps make lists of
> > >
> > >   - bug reports which never lead to any debug activity
> > >     (no responsible person/team was found, or a seemingly person/team
> > >     did not start to debug the report)
> > >
> > >   - known regressions on release,
> > >
> > >   - regressions that became known after release,
> > >
> > >   - subsystems with notable backlogs of old bugs,
> > >
> > >   - other categories?
> > >
> > > Select typical cases from each categories, analyze what went wrong in
> > > these cases, and try to identify practicable countermeasures.
> >
> > No maintainer or no maintainer who is debugging bug reports is the
> > major problem in all parts of your list.
> >
> > > Another approach:  Figure out areas where quality is exemplary and try
> > > to draw conclusions for areas where quality is lacking.
> >
> > ieee1394 has a maintainer who is looking after all bug reports he gets.
> >
> > Conclusion: We need such maintainers for all parts of the kernel.
> >
>
> I noticed some areas are well maintained because there is an awesome
> maintainer, or good and well coordinated team - and this is mostly in
> the "fun" areas ;) But there are "boring" areas that are about to be
> deprecated or no new development expected etc. It will be hard to get
> a dedicated person to take care of such. How about having people on
> rotation, or jury duty so to speak - for a period of time (completely
> voluntary!) Nice stats on the report about contributions in non-native
> areas for a developer would be great accomplishment and also good
> chance to look into other things! Besides, this way "old parts" will
> get attention to be be revised and re-implemented sooner. And we can
> post "Temp maintainer needed" list...
>

I'd vote for that, I've seen alot very bad code already within some
subsystems and critical problems which just have been ignored by some
maintainers.
It mostly helps if some volunteers read through existing code and
state out their considerations about implementations which they don't
like.

I just grep'ed some examples I noticed (note I do not want to jump
onto someone's toe here, just give some examples):

(sn9c102_ov7660.c)
...
        err += sn9c102_i2c_write(cam, 0x12, 0x80);
        err += sn9c102_i2c_write(cam, 0x11, 0x09);
        err += sn9c102_i2c_write(cam, 0x00, 0x0A);
        err += sn9c102_i2c_write(cam, 0x01, 0x80);
        err += sn9c102_i2c_write(cam, 0x02, 0x80);
        err += sn9c102_i2c_write(cam, 0x03, 0x00);
... (around 150 lines directly after each other doing such writes and
adding error values to a variable, I don't understand why someone
should add the errors but continue with sending 150 more updates, how
about one write failed but others succeeded for any reason)

(tvp5150.c)
static int tvp5150_read(struct i2c_client *c, unsigned char addr)
{
        unsigned char buffer[1];
        int rc;

        buffer[0] = addr;
        if (1 != (rc = i2c_master_send(c, buffer, 1)))
                tvp5150_dbg(0, "i2c i/o error: rc == %d (should be 1)\n", rc);

        msleep(10);

        if (1 != (rc = i2c_master_recv(c, buffer, 1)))
                tvp5150_dbg(0, "i2c i/o error: rc == %d (should be 1)\n", rc);

        tvp5150_dbg(2, "tvp5150: read 0x%02x = 0x%02x\n", addr, buffer[0]);

        return (buffer[0]);
}

(i2c issues within some driver)
        /* This code detects calls by card attach_inform */
        if (NULL == t->i2c.dev.driver) {
                tuner_dbg ("tuner 0x%02x: called during i2c_client
register by adapter's attach_inform\n", c->addr);

                return;
        }
... that code doesn't even work anymore since the i2c.dev.driver is
always initialized.

just reading through it and cleaning up some code isn't so difficult
and can be done by many people - if they're allowed/wanted to do so.

Markus
