Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYADWNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYADWNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYADWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:13:21 -0500
Received: from mx1.suse.de ([195.135.220.2]:44564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbYADWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:13:19 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less frequently
Date: Fri, 4 Jan 2008 23:11:57 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20080103442.621670000@suse.de> <200801041539.27370.ak@suse.de> <alpine.LFD.0.99999.0801041546230.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.99999.0801041546230.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042311.57837.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 21:34:15 Thomas Gleixner wrote:
> On Fri, 4 Jan 2008, Andi Kleen wrote:
> > > The kernel process request that _all_ contributors run their patches 
> > > through checkpath.pl and fix the problems.
> > 
> > That's new. When and by whom was that rule been introduced? And with what
> > rationale?
> 
> Documentation/SubmitChecklist

That says

" You should be able to justify all violations that remain in your patch."

I think I did that.

> > Anyways if you care so much about space<->tabs why don't you just write
> > a filter that converts spaces to tabs for incoming patches? Like it is
> > traditionally done for trailing white spaces? Would be a trivial perl script.
> 
> I need to fix up your sloppiness ?

That's the wrong way to see it.  

See it this way: Is forcing humans to convert spaces to tabs an useful activity?
Is rejecting patches for that and requiring repost a useful activity that 
improves Linux in any way? Will it help Linux to let people spend time
to convert spaces to tabs instead of writing patches or testing?

I don't think it is.  Arguably having tabs is nicer than spaces (I wont'
disagree with that).

But since it's something a simple script can do it's 
best to just handle it automatically. 
Then everybody can forget about that and it won't bother anymore again.

ftp://ftp.firstfloor.org/pub/ak/perl/converttabs

Anyways I could run converttabs over my pile and repost if you want,
but as pointed out elsewhere I think it would be better to just integrate
it into the merge flow -- then people could just forget about this forever.

Anyways my future patches will be always run through that.

> The only thing which is beyond ridiculous is your absolute refusal to
> play by the rules.

I question newly introduced rules that don't make sense to me. e.g the absolute
requirement of 100% checkpatch.pl compliance is certainly new.
 
> I just pointed out broken logic in your patch (vs. max_cpus) and your
> answer is just sloppy hand waving ignoring my completely valid
> point. After I pointed it out to you, you do not even have the modesty
> of acknowledging your error. 

I just fixed the patch instead. But you're right I was wrong on that.

> No, a second later you claim that we care 
> only about coding style and not the patch content itself.
> 
> Your findings of broken patches in the x86.git tree just prove that we
> are all human beings, 

Sure that's expected and I missed issues too when I was reviewing x86 patches
(the sentence came out perhaps a more harsh than originally intend) 

But my impression from reading the reviews was that a lot of the rejections
were based only on checkpatch.pl and not on logic checks and there were certainly
a few patches that clearly weren't logic reviewed.  If you do logic checks then that's 
fine of course -- feel free to prove me wrong on that front in the future.

To be honest I was also a little frustrated for patches that I consider
important cleanups (like the early-reserve code) I just get some checkpatch.pl 
complaints.

> but at least the people responsible for the 
> x86.git tree are able to admit their mistakes and fix them without
> arguing.

I fixed all objections that made sense, haven't reposted everything changed yet though.

> On the other side I'm waiting since month for any response 
> from you on a review for a pile of obviously broken patches which you
> wanted to push into 2.6.24.

What patches do you mean? I'm not of anything pending for .24.
 
> Your hyprocritical crusade 

I would prefer calling it "trying to improve inefficient newly introduced procedures
by constructive criticism" :-)

> is annoying the hell out of me, but feel 
> free to ridicule yourself further.

I'm sorry that you don't see my points. I guess I'll need to do a better job
at explaining them, but probably not tonight.

-Andi
 
