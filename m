Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbYBHSk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbYBHSk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbYBHSkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:40:07 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35103 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbYBHSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:40:04 -0500
Message-ID: <47ACA204.7030702@davidnewall.com>
Date: Sat, 09 Feb 2008 05:10:04 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>	 <47A5D9CD.5070001@davidnewall.com>	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>	 <47A5E67D.9040804@davidnewall.com>	 <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>	 <courier.47A8497B.0000472E@hawking.rebel.net.au>	 <1202240590.15090.119.camel@violet>  <47AB0A76.3000404@davidnewall.com>	 <1202411113.15090.263.camel@violet>  <47ABD317.5060805@davidnewall.com> <1202462101.15090.300.camel@violet>
In-Reply-To: <1202462101.15090.300.camel@violet>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Anyway you are still under the impression that a Linux kernel module can
> be original work in the end. We keep telling you that could be a wrong
> assumption which is based on the view of many of the kernel developers
> and of most of the lawyers that looked at this specific topic.
>   
Yes, I am of that view. I accept that I could be wrong, but that also
means that I could be right. We agree, so far. The important point is
that I could be right. What will be done when somebody brings forth such
an work? Will the restriction in EXPORT_SYMBOL_GPL be removed, or will
the driver be unfairly restricted from using those other modules? You
did agree I could be right, so positing such a driver, what happens? (I
predict nothing; the driver is unfairly restricted.)


Now, Alexander Terekhov has forwarded some links to me, relating to the
question of whether or not a Linux kernel module can be original. Bear
in mind that these links relate to U.S. Copyright Law.

In http://digital-law-online.info/lpdi1.0/treatise27.html, Professor Lee
A Hollaar discusses derivative work and linking with libraries. He says:

    Some have claimed that an application program that needs a library
    for its operation is a derivative work of that library. They take
    that position because the application program is "based on" the
    library because it was written to use the subroutines and other
    aspects of the library.

    Such a position is misplaced. Even though the definition of a
    derivative work contained in Section 101 seems to support such a
    reading when it talks about a derivative work’s being "based upon
    one or more preexisting works," the examples all illustrate
    derivative works where the original work is somehow incorporated or
    recast in the derivative work:

    A "derivative work" is a work based upon one or more preexisting
    works, such as a translation, musical arrangement, dramatization,
    fictionalization, motion picture version, sound recording, art
    reproduction, abridgment, condensation, or any other form in which a
    work may be recast, transformed, or adapted. A work consisting of
    editorial revisions, annotations, elaborations, or other
    modifications which, as a whole, represent an original work of
    authorship, is a "derivative work". {FN109: 17 U.S.C. §101
    <http://www4.law.cornell.edu/uscode/17/101.html>}

    This need to use a portion of the original work in the derivative
    work is stated in the legislative history of the Copyright Act of
    1976, where the drafters discussed when the derivative work
    exclusive right is infringed:

    To be an infringement the "derivative work" must be "based upon the
    copyrighted work," and the definition in section 101 refers to "a
    translation, musical arrangement, dramatization, fictionalization,
    motion picture version, sound recording, art reproduction,
    abridgment, condensation, or any other form in which a work may be
    recast, transformed, or adapted." Thus, to constitute a violation of
    section 106(2), the infringing work must incorporate a portion of
    the copyrighted work in some form;


Let me say it: A work that incorporates no portion of a copyrighted work
is not derivative. He goes on to say:

    It could be argued that the component program really does include
    portions of the library that it uses – data structures that are
    passed as parameters, or even the parameter lists themselves. But
    elements dictated by external considerations are filtered out when
    trying to determine whether there is copyright infringement.


Elsewhere he says, by implication, that "elements like the overall
program structure or architecture and data structures that are ...
dictated by external or efficiency considerations" are not "protected by
the original program’s copyright".

He finishes this part of his treatise by saying:

    No other conclusion makes sense. If it were not the case, then any
    program using the applications program interfaces (APIs) of an
    operating system could be considered a derivative work of that
    operating system.


Another germane reference provided by Alexander

A lengthy article by Prof. Dr. Lothar Determann can be found at
http://www.usfca.edu/law/determann/softwarecombinations060403.pdf
(DANGEROUS LIAISONS – SOFTWARE COMBINATIONS AS DERIVATIVE WORKS?). In
the abstract, Prof. Dr. Determann writes:

    The article concludes that most forms of software combinations are
    less dangerous than commonly assumed, because they do not constitute
    derivative works (but instead either compilations or sui generis
    aggregations outside the scope of the copyright owner’s exclusive
    rights), and a number of statutes and legal doctrines significantly
    limit a copyright owner’s ability to contractually prohibit software
    combinations that do not also constitute derivative works under
    copyright law.


In the Introduction he says:

    [C]ourts and commentators have not yet developed general rules for
    the qualification of software combinations as derivative works, and
    the place and role of derivative works within the statutory context
    of compilations, collective works and other types of aggregations
    does not seem to have been examined in depth yet with respect to
    software combinations.


>From this we must conclude that any claim that kernel modules can only
be derivative is wrong. The courts haven't given us direction yet, so
nobody knows for sure. He goes on to explain a bit about what it is to
be a new and non-derivative work:

    If the creator of a new work takes very little of an existing work
    or takes only non-protectable content (e.g., ideas, facts) or
    changes so much that the new work does not bear a close resemblance
    to the existing work, the new creation is simply a new work of
    authorship––and not a derivative of the existing work. After all,
    most new works are influenced to some extent by existing works.


He repeats this:

    [A] new (non-derivative) work[:] (if only very little of or
    non-protectable elements of the existing materials are present in
    the new work or if the new work does not bear a substantial
    resemblance to the existing work)


He goes on to discuss the Copyright Act, and quotes from it:

    In no case does copyright protection for an original work of
    authorship extend to any idea, procedure, process, system, method of
    operation, concept, principle, or discovery, regardless of the form
    in which it is described, explained, illustrated, or embodied in
    such work.


This defeats a claim that all kernel modules are derivative by virtue of
XXX.

Prof. Dr. Determann directly address the GPL. Others have suggested, in
the course of this discussion, that a Linux kernel module is intended to
be used with Linux and that that brings them into the scope of the GPL.
Prof. Dr. Determann says this:

    It is worth noting, however, that the GPL generally permits end
    users to execute GPLed code in any combination they want. According
    to Section 0 of the GPL, "[t]he act of running the Program is not
    restricted." As a result, software companies do not have to be
    concerned about invoking the "viral" effect of the GPL based on a
    contributory liability theory if they distribute their add-on
    programs separately, i.e., not in context with any GPLed code, even
    if the add-on programs are intended for combination with a
    particular version of GPLed code. End users who run add-on programs
    with the GPLed code would not infringe, because the GPL allows
    execution without any restrictions.


He also addresses the question of dynamic linking:

    Consequently, dynamic linking to GPLed programs would not normally
    trigger the application of the GPL to the linking program, even if
    both programs are distributed together.


He concludes:

    Software combinations are less dangerous liaisons as some have
    recently argued, particularly in the context of the GPL.

    Under the U.S. Copyright Act, a combination of a computer program
    with other software results in the preparation of a derivative work
    only if the combination (a) is sufficiently permanent, (b) contains
    significant and creative portions of the other software, (c) is
    creative in its own right, and (d) involves significant and creative
    internal changes to the other software. Most software combinations
    fail to meet one or more of these requirements and constitute either
    compilations, collective works, or non-copyrightable aggregations,
    and neither affect copyright owners’ adaptation rights under Section
    106 of the U.S. Copyright Act.


Now, Alan has made a big issue over numerous legal opinions he has
received, but he's been completely coy in the details. He has been
spreading hearsay. I have presented quite definite opinions from learned
and respected practitioners. He has presented nothing. It does rather
seem that he is quite wrong, and his recent huffiness, including the
emotive "liar" confrontation, nicely shows the balance between the two
arguments.

The reasonable conclusion is that an original, non-derivative USB driver
can be written, and let's face it, a number of them have been referred
to in the course of this discussion.

USB drivers must NOT be restricted to GPL-licence only; that would
damage Linux.

My thanks go to Alexander Terekhov for providing some very informative
links.

> And while you are talking to a lawyer. Ask him/her if it is okay to
> create a binary only application that uses a GPL library. Tell him/her
> that it is original work.

Where does this come from? It's right out of left field. Since I've
never suggested such a thing, could you please do me the courtesy of
retracting the suggestion that I have?
