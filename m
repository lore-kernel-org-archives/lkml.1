Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYBSUZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYBSUZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYBSUZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:25:22 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:17064 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYBSUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TVwzOANE974K+4PJaOO6GZKkeDFveGOC0JkLnY5EQpzeUxjpqM+ImJpff0yWwDxO5CvymUI4d5a800qBSjCeetjo+l9E6hXq65aPZO7xPLtZrEqz9eWJMQfjZQ+Mjaj9D/jJPSQmKdUF2stSlZfrt2BpE6jeuDwhqeEIF+qbxKQ=
Message-ID: <72dbd3150802191225v3d3363ffq8289159807988e46@mail.gmail.com>
Date: Tue, 19 Feb 2008 12:25:18 -0800
From: "David Rees" <drees76@gmail.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: random wedges with 2.6.25-rc*
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080219191035.252d5787@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219191035.252d5787@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 10:10 AM, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> Somewhere post 2.6.24, the kernel started getting very
> temperamentful. I experience random hangs and wedges very often.

FWIW, on my Fedora 8 Dell Vostro 1000 notebook, ever since updating to
kernel 2.6.23.15-137 I am getting frequent udev startup lockups on
boot.  Resetting and rebooting will get things past udev startup some
of the time, so it doesn't always hang. I'd guess it hangs about half
the time. Once past udev startup, everything works fine, no hangs. I
haven't seen this on a half dozen other desktops/servers running
Fedora 8.

Aside from that, everything else works fine. The previous kernel was
2.6.23.14-115, so I suspect that if these were related, the changes
were backported into the 2.6.23 stable tree in 2.6.23.15?

You can view the reported list of differences between the two kernels
in the package announcement:
https://www.redhat.com/archives/fedora-package-announce/2008-February/msg00255.html

-Dave
