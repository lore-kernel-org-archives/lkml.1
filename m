Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbXJMIKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbXJMIKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXJMIKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:10:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:40188 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbXJMIKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pmToZJ6zppdlI1bzA4YXNbKYNMSH2M8FgSeOpc+xodb7D56udvwyeQZm5s8p5a7rE2DiPqsXgu9SlJzWeceNXane+R+96P+sQ6QhUy0IkA8YRuFZHP0JqMVuXVfi9rT5bj/Y2dfKzKZyUDMh5Qe1gT8UkU8JC220DjaS1x0TRyg=
Message-ID: <84144f020710130110r6b13389aj43bb7b79ecd5e1b7@mail.gmail.com>
Date: Sat, 13 Oct 2007 11:10:19 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: How to find slab\'s usage?
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Albert Cahalan" <acahalan@gmail.com>
In-Reply-To: <200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>
	 <84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com>
	 <200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
X-Google-Sender-Auth: 39111890328b7d3a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/12/07, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > I saw /proc/meminfo and it seems to me that slab is leaking memory.
> > > But /usr/bin/slabtop claims /proc/slabinfo is missing.

At some point in time, I wrote:
> > Do you have CONFIG_SLUB enabled? Try looking into /sys/slab/.

On 10/13/07, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> Yes. There is /sys/slab/ .
> But are there any tools for browsing like /usr/bin/slabtop ?
> Is
>   cd /sys/slab/; for i in *; do echo -n $i " "; cat $i/slabs; done
> the only way currently available?

I don't think slabtop in procps has been updated to support slub. Christoph?

                            Pekka
