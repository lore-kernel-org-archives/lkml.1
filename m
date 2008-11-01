Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbYKAJlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbYKAJlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 05:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYKAJlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 05:41:13 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:59269 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYKAJlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 05:41:11 -0400
Message-ID: <490C2432.40804@free.fr>
Date: Sat, 01 Nov 2008 10:41:06 +0100
From: Thierry Merle <thierry.merle@free.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       greg@kroah.com, linux-dvb@linuxtv.org, em28xx@mcentral.de
Subject: Re: [linux-dvb] em28xx merge process issues with linuxtv and upstream
 kernel
References: <490B7EE5.5030701@powercraft.nl>
In-Reply-To: <490B7EE5.5030701@powercraft.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jelle,

Jelle de Jong a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello everybody,
> 
> I would like to discuss some issues with the em28xx-new project and the
> re-merging process with the upstream code and the linuxtv project.
> 
> First I would like to say that I am not an active developer on this
> project, but a very heavy user that followed the project very close and
> made some documentation, packages, helped getting some issues discussed
> and some devices added. This project is important for me because I need
> it to be merged successfully and with width support so it will become
> maintainable on large basis.
> 
> This is the situation:
> 
> Markus Rechberger has worked for more than 3 years on a clone/fork of
> the official code, creating the em28xx-new [1] project. He has worked
> very very hard on this project and produced a lot of code and provides a
> lot of support to the users of his project. It takes lot of energy and
> resources to pull of this kind of work! I do really respect this work
> and hope others also do this!
> 
> In a good free software development process somebody would clone some
> work to his own personal repository, then add or fix one feature. Create
> a diff compared with the upstream code and then. Commit the patch with
> good description to the upstream project, so this feature and its code
> changes can be reviewed, tested and supported. After this one feature
> fix and patch, a developer moves to his next feature and repeats to
> process so step by step and patch by patch the project grows. This
> understanding of the code bye a larger group of people will lead to a
> platform of developers that can maintain and contribute to the project.
> This would be the proper way of doing things it most cases, but a
> developer need to know and understand or mentored with this from the start.
> 
> However sometimes a developer works very hard on the code creating lots
> of new features, adding support for lots of new devices and fixes lots
> of issues without committing patches during the process. After 3 years
> or more its understandable that it can lead to a code base almost
> unrecognizable from the initial cloned code base. So what to do now! To
> ask from the developer to completely separate all his work in individual
> patches that can be committed to upstream is almost unrealistic. A good
> plan needs to be created and discussed by the people that matter.
> 
> In this case I have seen several attempts of Markus to make large
> patches and some smaller to try getting his code merged upstream, but
> they were after short discussion rejected, because they did not fit the
> one patch for one fix, feature, etcetera standard/idea.
> 
The last attempt was rejected because the patches were adding duplicate drivers rather than improving the existing ones.
In the same project, 2 drivers managing the same hardware is not correct.
Markus (or another people, why Markus may be the only person to do that?) should propose patches of the existing drivers, without breaking the v4l-dvb APIs.
- First, the tuners and video decoders modifications shall be merged since they are used by several existing drivers.
- Then the em28xx driver shall be improved.
And this is what Markus started (thanks for this initiative) but this is hard to spend time on these minor things while supporting problems because of being out-of-kernel.

v4l-dvb people and Markus would be glad to see his drivers in the mainstream kernel.

> I am going to ask for understanding of both the side of Markus that
> worked very hard on his code, and that of the upstream developers. There
> are both valid reasons on how they did there things.
> 
> But we need a solution to get all the code back into the upstream
> project so it can go into the kernel project and eventually be delivered
> at the Linux distributions and all there users, so no custom compiling,
> custom package install are required and non transparent bug reports can
> be stopped.
> 
> Is it possible for an upstream developer to step forward and take on the
> task of merging the code of Markus back into mainstream, all questions
> on the code can be discuses on several mailing-list [2] of choice.
> 
Well, I would say: "Make it so!" ;)

> Current the situation is kind of a hold-of, the issues are not being
> discussed, the problem is not addressed, so no process is made and
> during this time users are suffering from non working nor good supported
> devices for there hybrid dvb-t/analog broadcast experiences under Linux.
> 
> I hope this lead to a productive discussion that will get the code to
> the end users through there main distribution systems.
> 
I hope so, just to stop these useless discussions that do not discuss on patches.

Cheers,
Thierry
