Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYHHH6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYHHH6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYHHH6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:58:42 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28486 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYHHH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:58:41 -0400
Date: Fri, 8 Aug 2008 01:58:17 -0600
From: Alex Chiang <achiang@hp.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>,
       Jochen Vo? <jochen.voss@googlemail.com>
Subject: Re: [PATCH] A development process document, V2
Message-ID: <20080808075817.GA16055@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Amanda McPherson <amanda@amcpherson.com>,
	Jiri Kosina <jkosina@suse.cz>, Roland Dreier <rdreier@cisco.com>,
	Jochen Vo? <jochen.voss@googlemail.com>
References: <20080731111443.2179bf4c@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731111443.2179bf4c@bike.lwn.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jonathan Corbet <corbet@lwn.net>:
> Here is an updated version of the development process document;
> hopefully I've done a reasonable job of addressing everybody's
> comments.  Please let me know if you find anything else in need of
> attention.

Hi Jon,

Here are a few more suggestions, mostly around clarity (and a
very few brevity suggestions).

I didn't re-wrap any of the paragraphs to make the diff easier to
read.

Again, feel free to accept/disregard what you like. Hope some of
this was helpful.

cheers,

/ac



diff --git a/Documentation/development-process/1.Intro b/Documentation/development-process/1.Intro
index 5f88a1c..1972e04 100644
--- a/Documentation/development-process/1.Intro
+++ b/Documentation/development-process/1.Intro
@@ -32,7 +32,7 @@ One of the most compelling features of Linux is that it is accessible to
 these developers; anybody with the requisite skills can improve Linux and
 influence the direction of its development.  Proprietary products cannot
 offer this kind of openness, which is a characteristic of the free software
-process.  But, if anything, the kernel is even more open than most other
+process.  If anything, the kernel is even more open than most other
 free software projects.  A typical three-month kernel development cycle can
 involve over 1000 developers working for more than 100 different companies
 (or for no company at all).
@@ -105,7 +105,7 @@ discussed in greater detail later in this document.  Consider:
 
   Code which is in the mainline, instead, does not require this work as the
   result of a simple rule requiring developers to fix any code which breaks
-  as the result of an API change.  So code which has been merged into the
+  as the result of an API change.  Code which has been merged into the
   mainline has significantly lower maintenance costs.
 
 - Beyond that, code which is in the kernel will often be improved by other
@@ -134,7 +134,7 @@ discussed in greater detail later in this document.  Consider:
   users over to the in-tree version.
 
 - Contribution of code is the fundamental action which makes the whole
-  process work.  By contributing your code you can add new functionality to
+  process work.  Your contribution can add new functionality to
   the kernel and provide capabilities and examples which are of use to
   other kernel developers.  If you have developed code for Linux (or are
   thinking about doing so), you clearly have an interest in the continued
@@ -147,20 +147,20 @@ There are, however, additional factors which should be taken into account
 before considering any sort of binary-only kernel code distribution.  These
 include:
 
-- The legal issues around the distribution of proprietary kernel modules
+- The legal issues regarding the distribution of proprietary kernel modules
   are cloudy at best; quite a few kernel copyright holders believe that
   most binary-only modules are derived products of the kernel and that, as
   a result, their distribution is a violation of the GNU General Public
-  license (about which more will be said below).  Your author is not a
+  License (discussed further below).  Your author is not a
   lawyer, and nothing in this document can possibly be considered to be
   legal advice.  The true legal status of closed-source modules can only be
   determined by the courts.  But the uncertainty which haunts those modules
-  is there regardless.
+  exists regardless.
 
 - Binary modules greatly increase the difficulty of debugging kernel
-  problems, to the point that most kernel developers will not even try.  So
-  the distribution of binary-only modules will make support harder for
-  those who use them.
+  problems, to the point that most kernel developers will not even try.
+  The distribution of binary-only modules makes support harder for your
+  users.
 
 - Support is also harder for distributors of binary-only modules, who must
   provide a version of the module for every distribution and every kernel
@@ -175,14 +175,14 @@ include:
   problems. 
 
 Makers of embedded systems, in particular, may be tempted to disregard much
-of what has been said in this section in the belief that they are shipping
-a self-contained product which uses a frozen kernel version and requires no
+of the advice in this section in the belief that they are shipping
+a self-contained product which uses a frozen kernel version that requires no
 more development after its release.  This argument misses the value of
 widespread code review and the value of allowing your users to add
 capabilities to your product.  But these products, too, have a limited
 commercial life, after which a new version must be released.  At that
-point, venders whose code is in the mainline and well maintained will be
-much better positioned to get the new product ready for market quickly.
+point, vendors whose code is in the mainline and well maintained will enjoy
+a much shorter time-to-market development cycle.
 
 
 1.3: LICENSING
diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index c9492ff..e863ebe 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -2,7 +2,7 @@
 
 Linux kernel development in the early 1990's was a pretty loose affair,
 with relatively small numbers of users and developers involved.  With a
-user base in the millions and with some 2,000 developers involved of the
+user base in the millions and with some 2,000 developers involved in the
 course of one year, the kernel has since had to evolve a number of
 processes to keep development happening smoothly.  A solid understanding of
 how the process works is required in order to be an effective part of it.
@@ -107,8 +107,8 @@ mainline for the next development kernel.  Continuing our 2.6.25 example,
 the history (as of this writing) is:
 
 	May 1		2.6.25.1
-	May 6		2.6.25.2 
-	May 9		2.6.25.3 
+	May 6		2.6.25.2
+	May 9		2.6.25.3
 	May 15		2.6.25.4
 	June 7		2.6.25.5
 	June 9		2.6.25.6
@@ -311,10 +311,10 @@ pointers.
 By far the dominant source code management system used by the kernel
 community is git.  Git is one of a number of distributed version control
 systems being developed in the free software community.  It is well tuned
-for kernel development, in that it performs quite well when dealing with
+for kernel development, as it performs quite well when dealing with
 large repositories and large numbers of patches.  It also has a reputation
 for being difficult to learn and use, though it has gotten better over
-time.  Some sort of familiarity with git is almost a requirement for kernel
+time.  Some familiarity with git is almost a requirement for kernel
 developers; even if they do not use it for their own work, they'll need git
 to keep up with what other developers (and the mainline) are doing.
 
@@ -367,12 +367,12 @@ There are lists hosted elsewhere, though; a number of them are at
 lists.redhat.com.
 
 The core mailing list for kernel development is, of course, linux-kernel.
-This list is an intimidating place to be; volume can reach 500 messages per
+This list can be intimidating; volume can reach 500 messages per
 day, the amount of noise is high, the conversation can be severely
 technical, and participants are not always concerned with showing a high
 degree of politeness.  But there is no other place where the kernel
-development community comes together as a whole; developers will avoid this
-list at the risk of missing important information.
+development community comes together as a whole; developers who avoid this
+list risk missing important information.
 
 There are a few hints which can help with linux-kernel survival:
 
diff --git a/Documentation/development-process/3.Early-stage b/Documentation/development-process/3.Early-stage
index 207c8e7..abced84 100644
--- a/Documentation/development-process/3.Early-stage
+++ b/Documentation/development-process/3.Early-stage
@@ -105,8 +105,7 @@ the kernel community's standards.  Some examples include:
    virtual filesystem layer instead.  It also included features which could
    not easily be implemented without exposing the system to user-caused
    deadlocks.  The late revelation of these problems - and refusal to
-   address some of them - has caused Reiser4 to stay out of the mainline
-   kernel.
+   address some of them - has kept Reiser4 out of the mainline kernel.
 
  - The AppArmor security module made use of internal virtual filesystem
    data structures in ways which were considered to be unsafe and
@@ -128,14 +127,14 @@ linux-kernel; you are more likely to reach developers with expertise in the
 relevant subsystem and the environment may be more supportive.
 
 Finding maintainers can be a bit harder.  Again, the MAINTAINERS file is
-the place to start.  That file tends to not always be up to date, though,
+the place to start.  That file tends to be out of date, though,
 and not all subsystems are represented there.  The person listed in the
 MAINTAINERS file may, in fact, not be the person who is actually acting in
-that role currently.  So, when there is doubt about who to contact, a
+that role currently.  If there is doubt about who to contact, a
 useful trick is to use git (and "git log" in particular) to see who is
 currently active within the subsystem of interest.  Look at who is writing
 patches, and who, if anybody, is attaching Signed-off-by lines to those
-patches.  Those are the people who be best placed to help with a new
+patches.  Those are the people best placed to help with a new
 development project.
 
 If all else fails, talking to Andrew Morton can be an effective way to
@@ -145,8 +144,8 @@ track down a maintainer for a specific piece of code.
 3.4: WHEN TO POST?
 
 If possible, posting your plans during the early stages can only be
-helpful.  Describe the problem being solved and any plans that have been
-made on how the implementation will be done.  Any information you can
+helpful.  Describe the problem being solved and any plans you have
+for the implementation.  Any information you can
 provide can help the development community provide useful input on the
 project.
 
@@ -175,7 +174,7 @@ of a kernel development project, the better off everybody involved will be.
 Some readers may be thinking at this point that their kernel work is
 intended to support a product which does not yet have an officially
 acknowledged existence.  Revealing their employer's plans on a public
-mailing list may not be a viable option.  In cases like this, it is worth
+mailing list may not be a viable option.  In these cases, it is worth
 considering whether the secrecy is really necessary; there is often no real
 need to keep development plans behind closed doors.
 
diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
index c1443bc..c9e7965 100644
--- a/Documentation/development-process/4.Coding
+++ b/Documentation/development-process/4.Coding
@@ -18,14 +18,14 @@ Coding style
 
 The kernel has long had a standard coding style, described in
 Documentation/CodingStyle.  For much of that time, the policies described
-in that file were taken as being, at most, advisory.  As a result, there is
+in that file were considered, at most, advisory.  As a result, there is
 a substantial amount of code in the kernel which does not meed the coding
 style guidelines.  The presence of that code leads to two independent
 hazards for kernel developers.
 
-The first of these is to believe that the kernel coding standards do not
+The first hazard is to believe that the kernel coding standards do not
 matter and are not enforced.  The truth of the matter is that adding new
-code to the kernel is very difficult if that code is not coded according to
+code to the kernel is very difficult if that code is not written according to
 the standard; many developers will request that the code be reformatted
 before they will even review it.  A code base as large as the kernel
 requires some uniformity of code to make it possible for developers to
@@ -33,12 +33,12 @@ quickly understand any part of it.  So there is no longer room for
 strangely-formatted code.
 
 Occasionally, the kernel's coding style will run into conflict with an
-employer's mandated style.  In such cases, the kernel's style will have to
-win before the code can be merged.  Putting code into the kernel means
+employer's mandated style.  In such cases, the kernel's style takes
+precedence.  Putting code into the kernel means
 giving up a degree of control in a number of ways - including control over
 how the code is formatted.
 
-The other trap is to assume that code which is already in the kernel is
+The other trap is to assume that existing, non-conforming mainline code is
 urgently in need of coding style fixes.  Developers may start to generate
 reformatting patches as a way of gaining familiarity with the process, or
 as a way of getting their name into the kernel changelogs - or both.  But
@@ -150,7 +150,7 @@ retrofitted onto it.
 
 Once upon a time, Linux kernel code could be developed without thinking
 about the concurrency issues presented by multiprocessor systems.  Now,
-however, this document is being written on a dual-core laptop.  Even on
+however, even multiprocessor laptops (like the one used to write this document) are common.  And on
 single-processor systems, work being done to improve responsiveness will
 raise the level of concurrency within the kernel.  The days when kernel
 code could be written without thinking about locking are long past.
@@ -353,8 +353,8 @@ out.  Anything which might tempt a code janitor to make an incorrect
 4.4: INTERNAL API CHANGES
 
 The binary interface provided by the kernel to user space cannot be broken
-except under the most severe circumstances.  The kernel's internal
-programming interfaces, instead, are highly fluid and can be changed when
+except under the most severe circumstances.  But the kernel's internal
+programming interfaces are highly fluid and can be changed when
 the need arises.  If you find yourself having to work around a kernel API,
 or simply not using a specific functionality because it does not meet your
 needs, that may be a sign that the API needs to change.  As a kernel
diff --git a/Documentation/development-process/7.AdvancedTopics b/Documentation/development-process/7.AdvancedTopics
index 2cd6d49..d43ebaf 100644
--- a/Documentation/development-process/7.AdvancedTopics
+++ b/Documentation/development-process/7.AdvancedTopics
@@ -98,7 +98,7 @@ of the reasons why development should be done in private branches (which
 can be rewritten if necessary) and only moved into public branches when
 it's in a reasonably advanced state.
 
-As the mainline (or other tree upon which a set of changes is based)
+As the mainline (or any other tree upon which a set of changes is based)
 advances, it is tempting to merge with that tree to stay on the leading
 edge.  For a private branch, rebasing can be an easy way to keep up with
 another tree, but rebasing is not an option once a tree is exported to the
