Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYAZXow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYAZXow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 18:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYAZXoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 18:44:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55574 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbYAZXoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 18:44:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] Q: x86 suspend/hibernation code consolidation
Date: Sun, 27 Jan 2008 00:42:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <200801260132.09529.rjw@sisk.pl> <200801252147.27254.lenb@kernel.org>
In-Reply-To: <200801252147.27254.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801270042.38930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 26 of January 2008, Len Brown wrote:
> On Friday 25 January 2008 19:32, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > I'd like to move the 64-bit suspend/hibernation files from arch/x86/kernel to
> > arch/x86/power, modify the names of the 32-bit files already in
> > arch/x86/power and update the Makefiles accordingly, but there are some changes
> > queued for merging that touch the files in question.
> > 
> > When is the right time for making changes like that?
> > 
> > Rafael
> 
> In Cambridge, when we discussed cleanups that touch a lot of files
> but have no functional change -- somebody suggested that right
> after rc1 closes is a good time.  The reasoning was that they
> would not conflict with the functional changes in rc1.
> 
> However, I recall Linus saying something about "Andrew is special"
> WRT permission to push cleanups after the rc1 window; so I don't
> know what the final ruling was -- if there was such a ruling.

Well, I don't think there was a ruling, but perhaps sneaking it into -mm
after -rc1 would do the trick. ;-)

Rafael
