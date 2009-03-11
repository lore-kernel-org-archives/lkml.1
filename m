Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZCKNOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZCKNOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZCKNOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:14:31 -0400
Received: from mail10.dslextreme.com ([66.51.199.98]:53161 "HELO
	mail10.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753288AbZCKNOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:14:30 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 09:14:30 EDT
Subject: Re: [PATCH] Re: ALSA HDA Intel stoped to work in 2.6.16-*
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <s5h8wncihmk.wl%tiwai@suse.de>
References: <87wtfhx7rm.fsf@nurf.casa> <s5hek1fmzf4.wl%tiwai@suse.de>
	 <gou8k9$reh$1@ger.gmane.org> <200903071900.44762.rjw@sisk.pl>
	 <s5h63ikjool.wl%tiwai@suse.de> <loom.20090308T231221-216@post.gmane.org>
	 <s5h8wncihmk.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Mar 2009 06:07:20 -0700
Message-Id: <1236776849.4624.37.camel@the-omnibook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Re-adding mistakenly snipped CC's…)

On Wed, 2009-03-11 at 09:33 +0100, Takashi Iwai wrote:
> At Sun, 8 Mar 2009 23:21:13 +0000 (UTC),
> Daniel Gimpelevich wrote:
> > 
> > Takashi Iwai <tiwai <at> suse.de> writes:
> > 
> > > Daniel, how "incorrect" do you mean exactly?
> > > 
> > > As you cited, the above patch was added for the request for the
> > > specific model, so the patch itself is correct per definition.  What
> > > wrong could be the choice of the model option by the original poster,
> > > which I cannot judge.
> > > 
> > > Of course I have no objection to fix the model entry at all, but I
> > > need a more proper justification.
> > 
> > The master volume control appeared to be affecting the wrong control line,
> 
> Is it so with the latest 2.6.29 kernel?
> (Also you aren't accessing pulse plugin, right?)

Was using alsamixer to test, without pulseaudio running. The underlying
issue is unchanged in three years of commits.

> > and
> > there was no way to turn off IEC958, which appeared to be on by default.
> 
> This should work.
> 
> 	% amixer -Dhw:0 set IEC958 mute

It does work, but only after the patch I submitted (or by using the
equivalent module argument).

