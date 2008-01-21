Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYAUCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYAUCvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 21:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYAUCvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 21:51:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47642 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYAUCvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 21:51:07 -0500
Date: Mon, 21 Jan 2008 03:51:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>
Subject: Re: kbuild: improved Section mismatch detection
Message-ID: <20080121025111.GA26076@uranus.ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org> <20080120222754.GK8669@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120222754.GK8669@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 12:27:54AM +0200, Adrian Bunk wrote:
> On Sun, Jan 20, 2008 at 09:05:27PM +0100, Sam Ravnborg wrote:
> >...
> > Adrian reminded us that KCFLAGS=-fno-inline told
> > another story with more than 100 Section mismatch
> > warnings on 64 bit x86 with an allyesconfig build.
> >...
> 
> Not -fno-inline but -fno-inline-functions-called-once
> (completely different option).

Yep - looked that up after sending the mail.
A quick test shows no diference in # of generated Section mismatch
warnings for the two - which is good.

	Sam
